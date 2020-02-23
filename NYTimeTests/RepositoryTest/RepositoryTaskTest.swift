//
//  RepositoryTaskTest.swift
//  NYTimeTests
//
//  Created by Parth Dubal on 23/02/20.
//  Copyright © 2020 Parth Dubal. All rights reserved.
//

@testable import NYTime
import XCTest

class RepositoryTaskTest: XCTestCase {
    var networkCancellable: MockNetworkCanallable!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        networkCancellable = MockNetworkCanallable()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRepositoryTask() {
        let task = RepositoryTask(networkTask: networkCancellable)
        task.cancel()
        XCTAssertTrue(networkCancellable.cancelCalled)
    }
}
