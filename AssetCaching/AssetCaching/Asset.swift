//
//  Asset.swift
//  AssetCaching
//
//  Created by Cristian Gutu on 6/21/17.
//  Copyright © 2017 3Pillar Global. All rights reserved.
//

import Foundation

/// Class used to store info about the asset downloaded.
open class Asset: NSObject {
    /// The unique identifier of the assset.
    public let identifier: String
    /// The network url from where to download the asset.
    public var networkURL: URL
    public internal (set) var localURL: URL?

    ///  Constructs the asset
    ///
    /// - Parameters:
    ///   - networkURL: the network url from where to download the asset.
    public init?(networkURL: URL) {
        self.networkURL = networkURL
        let networkURLString = networkURL.absoluteString
        guard let userEncodedURL = networkURLString.addingPercentEncoding(withAllowedCharacters: .urlUserAllowed) else {
            return nil
        }

        identifier = userEncodedURL
    }

    /// Constructs the asset
    ///
    /// - Parameters:
    ///   - networkURLString: the network url string from where to download the asset.
    convenience public init?(networkURLString: String) {
        guard let urlString = networkURLString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return nil
        }
        guard let url = URL(string: urlString) else { return nil }

        self.init(networkURL: url)
    }

    /// Checks for equality between two asset objects
    open override func isEqual(_ object: Any?) -> Bool {
        guard let objectAsset = object as? Asset else { return false }
        if self === objectAsset { return true }
        return self.identifier == objectAsset.identifier
    }
}
