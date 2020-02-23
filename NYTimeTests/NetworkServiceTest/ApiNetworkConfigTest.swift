//
//  ApiNetworkConfigTest.swift
//  NYTimeTests
//
//  Created by Parth Dubal on 23/02/20.
//  Copyright © 2020 Parth Dubal. All rights reserved.
//

@testable import NYTime
import XCTest

class ApiNetworkConfigTest: XCTestCase {
    var config: NetworkConfigurable!
    let url = URL(string: "https://mock.com")!
    let headers = ["": ""]
    let queryParams = ["": ""]
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        config = ApiNetworkConfig(baseURL: url, headers: headers, queryParameters: queryParams)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNetworkConfigurable() {
        XCTAssertEqual(config.baseURL, url)
        XCTAssertEqual(config.headers, headers)
        XCTAssertEqual(config.queryParameters, queryParams)
    }
}
