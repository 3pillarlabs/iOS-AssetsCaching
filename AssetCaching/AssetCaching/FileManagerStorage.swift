//
//  FileManagerStorage.swift
//  3PGImageCacheLibrary
//
//  Created by Liliana Bulgaru on 10/10/16.
//  Copyright © 2016 3Pillar Global. All rights reserved.
//

import Foundation

class FileManagerStorage: AssetStorage {
    static let assetDataFolderName = "asset-data"

    func hasAsset(_ asset: Asset) -> Bool {
        guard let fileURL = self.assetsURL(for: asset.identifier) else { return false }
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: fileURL.path) {
            asset.localURL = fileURL
            return true
        }
        return false
    }

    func store(data: Data, for asset: Asset, completion: Completion?) {
        guard let assetURL = self.assetsURL(for: asset.identifier) else {
            completion?(asset, AssetError.unableToCreateAssetURL)
            return
        }
        do {
            try data.write(to: assetURL)
            asset.localURL = assetURL
            completion?(asset, nil)
        } catch {
            completion?(asset, error)
        }
    }

    @discardableResult func clear() -> Bool {
        guard let assetsDirectory = assetsFolder() else { return false }
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(at: assetsDirectory)
            return true
        } catch {
            return false
        }
    }

    // MARK: Private functionality

    private func documentsDirectory() -> URL? {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        guard let documentsDirectory = paths.first else { return nil }
        return URL(fileURLWithPath: documentsDirectory)
    }

    private func assetsFolder() -> URL? {
        guard let url = documentsDirectory()?.appendingPathComponent(FileManagerStorage.assetDataFolderName) else {
            return nil
        }
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: url.path) {
            do {
                try fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch {
                return nil
            }
        }

        return url
    }

    private func assetsURL(for assetIdentifier: String) -> URL? {
        return assetsFolder()?.appendingPathComponent(assetIdentifier)
    }
}
