//
//  LocalizeTest.swift
//  NYTimeTests
//
//  Created by Parth Dubal on 23/02/20.
//  Copyright © 2020 Parth Dubal. All rights reserved.
//

@testable import NYTime
import XCTest

class LocalizeTest: XCTestCase {
    func testLocalize() {
        let testoutput = "This is for localize test"
        XCTAssertEqual(localize(key: "localizeTest"), testoutput) // This indicates key exist
        XCTAssertEqual(localize(key: "localize"), "localize") // This indicates key does not exist
    }
}
