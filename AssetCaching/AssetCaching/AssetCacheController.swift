//
//  AssetCacheController.swift
//  AssetCaching
//
//  Created by David Livadaru on 06/09/2017.
//  Copyright © 2017 3Pillar Global. All rights reserved.
//

import Foundation

public typealias Completion = (_ asset: Asset, _ error: Error?) -> Void

public protocol AssetCacheController {
    /// Fetch asset for provided url.
    ///
    /// - Parameters:
    ///   - urlString: the url as string where resource can be located.
    ///   - completion: completion which called when fetching and/or caching was complete. 
    ///     Completion is called on main queue.
    func fetchAsset(_ asset: Asset, completion: Completion?)

    /// Deletes all cached assets. Note that all Asset instances are no longer valid and should be deallocated.
    func clearCache()
}
