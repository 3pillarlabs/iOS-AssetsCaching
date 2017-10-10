//
//  AssetManager.swift
//  3PGImageCacheLibrary
//
//  Created by Liliana Bulgaru on 10/10/16.
//  Copyright © 2016 3Pillar Global. All rights reserved.
//

import Foundation

open class AssetManager: AssetCacheController {
    private var storage: AssetStorage = FileManagerStorage()
    var networkRequester: NetworkRequester = NetworkManager()

    public var requesterDelegate: NetworkRequesterDelegate? {
        get {
            return networkRequester.delegate
        }
        set {
            networkRequester.delegate = newValue
        }
    }

    public init() {
    }

    public func fetchAsset(_ asset: Asset, completion: Completion? = nil) {
        if storage.hasAsset(asset) {
            completion?(asset, nil)
        } else {
            networkRequester.downloadData(for: asset, completion: { [weak self] (asset, data, error) in
                if let data = data, error == nil {
                    self?.storage.store(data: data, for: asset, completion: {(asset, error) in
                        DispatchQueue.main.async {
                            completion?(asset, error)
                        }
                    })
                } else {
                    completion?(asset, error)
                }
            })
        }
    }

    public func clearCache() {
        storage.clear()
    }
}
