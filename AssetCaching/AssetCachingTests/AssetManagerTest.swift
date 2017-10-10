//
//  AssetManagerTest.swift
//  AssetCaching
//
//  Created by Bogdan Todea on 9/11/17.
//  Copyright © 2017 3Pillar Global. All rights reserved.
//

import XCTest
@testable import AssetCaching
import OHHTTPStubs
import Reachability

class AssetManagerTests: XCTestCase {
    func testFetchAsset_CheckSuccess() {
        if let url = URL(string: "http://www.google.com"), let asset = Asset(networkURL: url) {
            if let jsonObject = "{\"stubData\":\"mockedValue\"}".data(using: String.Encoding.utf8) {
                OHHTTPStubs.stubRequests(passingTest: {$0.httpMethod == "GET" && $0.url == asset.networkURL}) { _ in
                    return OHHTTPStubsResponse(data: jsonObject,
                                               statusCode: 200, headers: [ "Content-Type": "application/json" ])
                    }.name = "Stub for download"
            }
            let exp = expectation(description: "expected time to wait for result wait for async call")
            let assetManager = AssetManager()
            assetManager.networkRequester = TestNetworkManager()
            assetManager.fetchAsset(asset, completion: { (_, error) in
                OHHTTPStubs.removeAllStubs()
                exp.fulfill()
                XCTAssert(error == nil, "fetchAsset failed.")
            })
            waitForExpectations(timeout: URLRequest(url: url).timeoutInterval, handler: nil)
        } else {
            XCTFail("Test Failed, unable to create asset in order to test fetchAsset_Success")
        }
    }

    func testFectchAsset_CheckFailure() {
        if let url = URL(string: "http://www.google.com"),
            let asset = Asset(networkURLString: "http://www.google.com") {
            let exp = expectation(description: "expected time to wait for result wait for async call")
            let assetManager = AssetManager()
            assetManager.clearCache()
            assetManager.fetchAsset(asset, completion: { (_, error) in
                exp.fulfill()
                XCTAssert(error != nil, "fetchAsset failed.")
            })
            waitForExpectations(timeout: URLRequest(url: url).timeoutInterval, handler: nil)
        } else {
            XCTFail("Test Failed, unable to create asset in order to test fetchAsset_Failure")
        }
    }

    func testClearCache_CheckSuccess() {
        let fileManager = FileManager.default
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        if paths.isEmpty == false, let documentsDirectory = paths.first {
            let docDirectory = URL(fileURLWithPath: documentsDirectory)
            //let assetDataFolderName = "asset-data"
            let url = docDirectory.appendingPathComponent(FileManagerStorage.assetDataFolderName)
            if !fileManager.fileExists(atPath: url.path) {
                do {
                    try fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    XCTFail("Test Failed, unable to create documentsDirectory to test clearCache success")
                }
            }
            let assetManager = AssetManager()
            assetManager.clearCache()
            XCTAssert(fileManager.fileExists(atPath: url.path) == false, "clearCacheSuccess failed.")
        } else {
            XCTFail("Test Failed, unable to locate documentsDirectory to test clearCache success")
        }
    }

    func testRequesterDelegate_CheckSuccess() {
        let assetManager = AssetManager()
        let testDelegate = TestDelegate()
        assetManager.requesterDelegate = testDelegate
        XCTAssert(assetManager.requesterDelegate != nil, "RequesterDelegate test success failed")
    }
}
private class TestDelegate: NetworkRequesterDelegate {}
