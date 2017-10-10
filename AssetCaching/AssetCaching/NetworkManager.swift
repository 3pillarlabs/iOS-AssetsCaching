//
//  NetworkManager.swift
//  3PGImageCacheLibrary
//
//  Created by Liliana Bulgaru on 30/08/16.
//  Copyright © 2016 3Pillar Global. All rights reserved.
//

import Foundation
import Reachability

class NetworkManager: NSObject, NetworkRequester {
    weak var delegate: NetworkRequesterDelegate?

    private let networkQueue: OperationQueue
    private let exclusivityQueue: OperationQueue
    private var operationIDs: Set<String> = []
    private let exclusivityController = NetworkExclusivityController()

    override init() {
        networkQueue = OperationQueue()
        exclusivityQueue = OperationQueue()
        exclusivityQueue.maxConcurrentOperationCount = 1

        super.init()
    }

    func downloadData(for asset: Asset, completion: NetworkRequester.Completion?) {
        exclusivityQueue.addOperation { [weak self] in
            self?.exclusivityController.addCompletion(completion, for: asset)
        }
        if let operation = self.operation(for: asset) {
            networkQueue.addOperation(operation)
        }
    }

    func hasInternetConnection(urlString: String) -> Bool {
        let reachability = Reachability(hostname: urlString)
        return reachability?.isReachable ?? false
    }

    // MARK: Private functionality

    private func operation(for asset: Asset) -> Operation? {
        guard operationIDs.contains(asset.identifier) == false else { return nil }

        operationIDs.insert(asset.identifier)

        if !hasInternetConnection(urlString: asset.networkURL.absoluteString) {
            completeDownload(for: asset, with: nil, error: NetworkError.noInternetConnection)
            return nil
        }

        let delegateURLRequest = delegate?.requester?(requester: self, urlRequestFor: asset.networkURL)
        let urlRequest = delegateURLRequest ?? URLRequest(url: asset.networkURL)

        let delegateConfiguration = delegate?.requester?(requester: self, configurationFor: asset.networkURL)
        let configuration = delegateConfiguration ?? URLSessionConfiguration.ephemeral
        configuration.requestCachePolicy = .reloadIgnoringCacheData
        configuration.urlCache = nil

        let urlSession = URLSession(configuration: configuration)

        let dataTask = urlSession.dataTask(with: urlRequest) { [weak self] (data, _, error) in
            guard let strongSelf = self else { return }
            strongSelf.exclusivityQueue.addOperation {
                strongSelf.completeDownload(for: asset, with: data, error: error)
            }
        }

        return URLSessionTaskOperation(task: dataTask)
    }

    private func createURLRequest(for asset: Asset) -> URLRequest {
        return URLRequest(url: asset.networkURL)
    }

    private func completeDownload(for asset: Asset, with data: Data?, error: Error?) {
        let completion = exclusivityController.completion(for: asset)
        completion?(asset, data, error)
        exclusivityController.removeCompletion(for: asset)
        operationIDs.remove(asset.identifier)
    }
}

private class NetworkExclusivityController {
    private var store: [String: NetworkRequester.Completion] = [:]

    func completion(for asset: Asset) -> NetworkRequester.Completion? {
        return store[asset.identifier]
    }

    func addCompletion(_ completion: NetworkRequester.Completion?, for asset: Asset) {
        let currentCompletion = self.completion(for: asset)
        store[asset.identifier] = { (_ asset: Asset, _ data: Data?, _ error: Error?) in
            currentCompletion?(asset, data, error)
            completion?(asset, data, error)
        }
    }

    func removeCompletion(for asset: Asset) {
        store[asset.identifier] = nil
    }
}
