//
//  NYTimeUITests.swift
//  NYTimeUITests
//
//  Created by Parth Dubal on 22/02/20.
//  Copyright © 2020 Parth Dubal. All rights reserved.
//
@testable import NYTime
import XCTest

class NYTimeUITests: XCTestCase {
    let app = XCUIApplication()
    override func setUp() {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
    }

    func testSuccessLaunch() {
        app.launchArguments.append(UITestRunner.successRunnning)
        app.launch()

        let id = "NewListTableView"
        let tableView = app.tables[id]
        _ = tableView.waitForExistence(timeout: 0.1)
        XCTAssert(tableView.exists)

        let bottom = tableView.coordinate(withNormalizedOffset: CGVector(dx: 1.0, dy: 1.0))

        let scrollVector = CGVector(dx: 0.0, dy: -550.0)
        bottom.press(forDuration: 0.7, thenDragTo: bottom.withOffset(scrollVector))
        bottom.press(forDuration: 0.7, thenDragTo: bottom.withOffset(scrollVector))
    }

    func testFailureLaunch() {
        app.launchArguments.append(UITestRunner.failureRunning)
        app.launch()

        let failViewid = "failureView"
        let failView = app.otherElements[failViewid]
        _ = failView.waitForExistence(timeout: 1.0)
        XCTAssert(failView.exists)

        failView.buttons["tryAgainButton"].tap()

        XCTAssert(failView.exists)
    }
}
