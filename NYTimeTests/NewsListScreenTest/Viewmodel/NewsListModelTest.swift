//
//  NewsListModelTest.swift
//  NYTimeTests
//
//  Created by Parth Dubal on 23/02/20.
//  Copyright © 2020 Parth Dubal. All rights reserved.
//

@testable import NYTime
import XCTest

class NewsListModelTest: XCTestCase {
    var listModel: NewsListModel?

    func testEmptyModel() {
        let listModel = NewsListModel(page: 0, list: [])
        XCTAssertEqual(listModel.page, 0)
        XCTAssertTrue(listModel.list.isEmpty)
    }

    func testFillModel() {
        let mockList = NewsListItem.buildMock()

        var listModel = NewsListModel(page: 1, list: mockList)
        XCTAssertEqual(listModel.page, 1)
        XCTAssertFalse(listModel.list.isEmpty)

        XCTAssertEqual(listModel.list.first?.title, "title1")

        listModel.resetData()
        XCTAssertEqual(listModel.page, 0)
        XCTAssertTrue(listModel.list.isEmpty)
    }
}
