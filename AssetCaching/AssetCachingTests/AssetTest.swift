//
//  AssetTest.swift
//  AssetCaching
//
//  Created by Bogdan Todea on 9/18/17.
//  Copyright © 2017 3Pillar Global. All rights reserved.
//

import XCTest
@testable import AssetCaching

class AssetTest: XCTestCase {
    func testAssetCreationWithURL_CheckSuccess() {
        if let url = URL(string: "http://www.google.com") {
            let asset = Asset(networkURL: url)
            XCTAssert(asset != nil, "Test Failed, Asset creation failed")
        } else {
            XCTFail("Test Failed, unable to create asset")
        }
    }

    func testAssetCreationWithStringURL_CheckSuccess() {
        if let url = URL(string: "http://www.google.com") {
            let asset = Asset(networkURLString: url.absoluteString)
            XCTAssert(asset != nil, "Test Faield, Asset creation failed")
        } else {
            XCTFail("Test Failed, unable to create asset")
        }
    }

    func testAssetEquality_CheckSuccess() {
        if let url = URL(string: "http://www.google.com") {
            let firstAsset = Asset(networkURL: url)
            let secondAsset = Asset(networkURL: url)
            XCTAssert((firstAsset == secondAsset), "Test Failed, Asset equality not working")
        } else {
            XCTFail("Test Failed, unable to create assets")
        }
    }

    func testAssetEquality_CheckFailure() {
        if let firstAssetUrl = URL(string: "http://www.google.com"),
            let secondAssetUrl = URL(string: "http://www.apple.com") {
            let firstAsset = Asset(networkURL: firstAssetUrl)
            let secondAsset = Asset(networkURL: secondAssetUrl)
            XCTAssert(!(firstAsset == secondAsset), "Test Failed, Asset equality Failure not working")
        } else {
            XCTFail("Test Failed, unable to create assets")
        }
    }
}
