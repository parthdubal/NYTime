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

        nyTimeRepository = NYTimesRepository(session: networkService)

        let exception = expectation(description: "Loading data")
        _ = nyTimeRepository?.requestNewsList(query: "", page: 1, completion: { result in

            let list = try? result.get()
            XCTAssertNotNil(list)
            XCTAssertTrue(networkService.requestDidCall)
            exception.fulfill()
        })
        wait(for: [exception], timeout: 1.5)
    }

    func testFailureService() {
        let failnetworkService = FailureMockNetworkService()
        nyTimeRepository = NYTimesRepository(session: failnetworkService)
        let exception = expectation(description: "Loading data")
        _ = nyTimeRepository?.requestNewsList(query: "", page: 1, completion: { result in
            XCTAssertTrue(failnetworkService.requestDidCall)
            let list = try? result.get()
            XCTAssertNil(list)

            exception.fulfill()
        })
        wait(for: [exception], timeout: 1.0)
    }
}
