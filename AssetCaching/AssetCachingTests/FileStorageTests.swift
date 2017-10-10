//
//  FileStorageTests.swift
//  AssetCaching
//
//  Created by David Livadaru on 08/09/2017.
//  Copyright © 2017 3Pillar Global. All rights reserved.
//

import XCTest
@testable import AssetCaching

class TestNetworkManager: NetworkManager {
    override func hasInternetConnection(urlString: String) -> Bool {
        return true
    }
}

class FileStorageTests: XCTestCase {
    func testHasAsset_checkForFailure() {
        if let asset = Asset(networkURLString: "http://www.google.com") {
            let fileStorage = FileManagerStorage()
            let message = "`hasAsset` function returns true even if we are providing a new url."
            XCTAssert(fileStorage.hasAsset(asset) == false, message)
        } else {
            XCTFail("Unable to create asset in order to set `hasAsset` from FileManagerStorage.")
        }
    }

    func testHasAsset_checkForSuccess() {
        let assetManager = AssetManager()
        assetManager.networkRequester = TestNetworkManager()
        if let url = URL(string: "http://www.google.com"), let asset = Asset(networkURL: url) {
            assetManager.fetchAsset(asset, completion: {(_, error) in
                XCTAssert(error == nil, "Failed to fetch asset.")
                let fileStorage = FileManagerStorage()
                XCTAssert(fileStorage.hasAsset(asset), "File manager is not able to test a fetched asset.")
            })
        } else {
            XCTFail("Unable to create asset in order to set `hasAsset` from FileManagerStorage.")
        }
    }

    func testStoreData_checkForSuccess() {
        let fileStorage = FileManagerStorage()
        if let url = URL(string: "http://www.google.com"), let asset = Asset(networkURL: url),
            let data = "testStoreData".data(using: .utf8) {
            fileStorage.store(data: data, for: asset, completion: { (asset, error) in
                XCTAssert(error == nil, "Failed to store data")
                XCTAssert(fileStorage.hasAsset(asset), "No asset found, store data failed")
            })
        } else {
            XCTFail("Unable to create asset in order to store data.")
        }
    }

    func testClear_checkSuccess() {
        let fileStorage = FileManagerStorage()
        XCTAssert(fileStorage.clear(), "Unable to clear storage")
    }
}
