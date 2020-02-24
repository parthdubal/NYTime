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
    let mockList = NewsListItem.buildMock()
    override func setUp() {
        listModel = NewsListModel(page: 0, list: mockList)
    }

    override func tearDown() {
        listModel = nil
    }

    func testEmptyModel() {
        let listModel = NewsListModel(page: 0, list: [])
        XCTAssertEqual(listModel.page, 0)
        XCTAssertTrue(listModel.list.isEmpty)
    }

    func testFillModel() {
        XCTAssertNotNil(listModel)
        XCTAssertEqual(listModel?.page, 0)
        XCTAssertFalse(listModel!.list.isEmpty)
        XCTAssertEqual(listModel?.list.first?.title, "title1")
    }

    func testResetData() {
        XCTAssertFalse(listModel!.list.isEmpty)
        listModel?.resetData()
        XCTAssertTrue(listModel!.list.isEmpty)
    }

    func testAppendNewsList() {
        listModel?.appendNewsList(newList: mockList)
        XCTAssertTrue(listModel!.list.count > mockList.count)
        XCTAssertEqual(listModel!.page, 1)
    }

    func testUpdateImage() {
        listModel?.updateImage(index: 1, image: UIImage.placeholderImage)
        XCTAssertTrue(listModel!.list[1].downloaded)
    }
}
