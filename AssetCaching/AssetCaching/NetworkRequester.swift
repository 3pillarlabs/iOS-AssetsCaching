//
//  NetworkRequester.swift
//  AssetCaching
//
//  Created by David Livadaru on 06/09/2017.
//  Copyright © 2017 3Pillar Global. All rights reserved.
//

import Foundation

@objc public protocol NetworkRequesterDelegate: class {
    /// Method used to create an URLRequest for the asset
    ///
    /// - Parameters:
    ///   - requester: The requester for whom to create the url request
    ///   - url: The url for whom to create and url request
    /// - Returns: An url request
    @objc optional func requester(requester: NetworkRequester, urlRequestFor url: URL) -> URLRequest
    /// Method used to create the session configuration
    ///
    /// - Parameters:
    ///   - requester: The requester for whom to create the session configuration
    ///   - url: The url for whom to create the session configuration
    /// - Returns: An url session configuration
    @objc optional func requester(requester: NetworkRequester, configurationFor url: URL) -> URLSessionConfiguration
}

@objc public protocol NetworkRequester {
    weak var delegate: NetworkRequesterDelegate? { get set }
    typealias Completion = (_ asset: Asset, _ data: Data?, _ error: Error?) -> Void

    /// Performs download of data for asset.
    ///
    /// - Parameters:
    ///   - asset: the asset for which we need data.
    ///   - completion: completion which called when downloas was complete or if there was an error.
    ///   Completion is called on private queue.

    func downloadData(for asset: Asset, completion: Completion?)
}
