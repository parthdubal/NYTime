//
//  APIEndPointProviderTest.swift
//  NYTimeTests
//
//  Created by Parth Dubal on 23/02/20.
//  Copyright © 2020 Parth Dubal. All rights reserved.
//

@testable import NYTime
import XCTest

class APIEndPointProviderTest: XCTestCase {
    var networkConfig: NetworkConfigurable?
    let baseURL = URL(string: "https://www.example.com/")!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        networkConfig = ApiNetworkConfig(baseURL: baseURL)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        networkConfig = nil
    }

    func testObjectContents() {
        let path = "sc/data/1.json"
        let query = ["q": "test"]
        let header = ["key": "key-value"]

        let apiPoint = APIEndPointProvider.mockAPIPoint(path: path,
                                                        isFullPath: false,
                                                        method: .GET,
                                                        query: query,
                                                        header: header)
        XCTAssertEqual(apiPoint.isFullPath, false)
        XCTAssertEqual(apiPoint.path, path)
        XCTAssertEqual(apiPoint.headerParamaters, header)
    }

    func testURLCreation() {
        let path = "sc/data/1.json"
        let query = ["q": "test"]
        let header = ["key": "key-value"]

        let apiPoint = APIEndPointProvider.mockAPIPoint(path: path,
                                                        isFullPath: false,
                                                        method: .GET,
                                                        query: query,
                                                        header: header)

        let url = try? apiPoint.url(with: networkConfig!)
        XCTAssertNotNil(url)
        XCTAssertEqual(url?.absoluteString, "https://www.example.com/sc/data/1.json?q=test")
        XCTAssertTrue(url?.query?.contains("test") ?? false)
    }

    func testURLRequestCreation() {
        let path = "sc/data/1.json"
        let query = ["q": "test"]
        let header = ["key": "key-value"]

        let apiPoint = APIEndPointProvider.mockAPIPoint(path: path,
                                                        isFullPath: false,
                                                        method: .GET,
                                                        query: query,
                                                        header: header)

        let urlRequst = try? apiPoint.urlRequest(networkConfig!)
        XCTAssertNotNil(urlRequst)
        XCTAssertEqual(urlRequst?.httpMethod, HTTPMethod.GET.rawValue)
        XCTAssertEqual(urlRequst?.allHTTPHeaderFields?.capacity, 1) // Single header key value passed..
    }
}
