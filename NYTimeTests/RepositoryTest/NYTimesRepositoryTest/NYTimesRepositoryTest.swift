//
//  NYTimesRepositoryTest.swift
//  NYTimeTests
//
//  Created by Parth Dubal on 23/02/20.
//  Copyright © 2020 Parth Dubal. All rights reserved.
//

@testable import NYTime
import XCTest

class NYTimesRepositoryTest: XCTestCase {
    var nyTimeRepository: NYTimesRepository?
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        nyTimeRepository = nil
    }

    func testSuccessService() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let data = try? Data(contentsOf: URL(fileURLWithPath: Bundle.helperBundle.mockNews))

        let resultData = data ?? Data()
        let networkService = SuccessMockNetworkService(data: resultData)

        nyTimeRepository = NYTimesRepository(newsService: networkService, imageService: networkService, noImageData: Data())

        let exception = expectation(description: "Loading data")
        _ = nyTimeRepository?.searchNewsArticle(query: "", page: 1, completion: { result in

            let list = try? result.get()
            XCTAssertNotNil(list)
            XCTAssertTrue(networkService.requestDidCall)
            exception.fulfill()
        })
        wait(for: [exception], timeout: 1.5)
    }

    func testFailureService() {
        let failnetworkService = FailureMockNetworkService()
        nyTimeRepository = NYTimesRepository(newsService: failnetworkService, imageService: failnetworkService, noImageData: Data())
        let exception = expectation(description: "Loading data")
        _ = nyTimeRepository?.searchNewsArticle(query: "", page: 1, completion: { result in
            XCTAssertTrue(failnetworkService.requestDidCall)
            let list = try? result.get()
            XCTAssertNil(list)

            exception.fulfill()
        })
        wait(for: [exception], timeout: 1.0)
    }

    func testSearchArticleAPIPoints() {
        let query = "singapore"
        let page = 2

        let searchAPI = NYTImesAPIPoints.searchArticle(query: query, page: page)

        let apiPoint = searchAPI.toAPIEndPoint()
        let isValidQueryParameter = apiPoint.queryParameters.contains { $0.key == "q" && ($0.value as? String) == query }
        let isValidPageParameter = apiPoint.queryParameters.contains { $0.key == "page" && ($0.value as? String) == "\(page)" }
        XCTAssertFalse(apiPoint.isFullPath)
        XCTAssertTrue(isValidQueryParameter)
        XCTAssertTrue(isValidPageParameter)
    }

    func testphotoServiceAPIPoints() {
        let imagePath = "images/2020/02/19/multimedia/19xp-spy/merlin_168923481_b9f549a6-0620-404f-b136-5f4c91943247-articleLarge.jpg"

        let photoAPI = NYTImesAPIPoints.photoService(imagePath: imagePath)
        let apiPoint = photoAPI.toAPIEndPoint()

        XCTAssertFalse(apiPoint.isFullPath)
        XCTAssertTrue(apiPoint.headerParamaters.isEmpty)
    }
}
