//
//  AssetStorage.swift
//  AssetCaching
//
//  Created by David Livadaru on 06/09/2017.
//  Copyright © 2017 3Pillar Global. All rights reserved.
//

import Foundation

protocol AssetStorage {
    /// Checks if asset is available in cache.
    /// If asset is available in cache, then the `localURL` property of Asset is updated.
    ///
    /// - Parameter asset: the asset to be checked.
    /// - Returns: `true` if asset is cached, `false` otherwise.
    func hasAsset(_ asset: Asset) -> Bool

    /// Store data and associated with the asset.
    ///
    /// - Parameters:
    ///   - data: the data which has to stored.
    ///   - asset: the asset associated with data.
    ///   - completion: completion which is called after store operation has finished.
    ///     Completion is called on a private queue.
    func store(data: Data, for asset: Asset, completion: Completion?)

    /// Deletes all data from storage.
    @discardableResult func clear() -> Bool
}
