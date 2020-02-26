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
        listModel = NewsListModel(page: 0, articleList: mockList)
    }

    override func tearDown() {
        listModel = nil
    }

    func testEmptyModel() {
        let listModel = NewsListModel(page: 0, articleList: [])
        XCTAssertEqual(listModel.page, 0)
        XCTAssertTrue(listModel.articleList.isEmpty)
    }

    func testFillModel() {
        XCTAssertNotNil(listModel)
        XCTAssertEqual(listModel?.page, 0)
        XCTAssertFalse(listModel!.articleList.isEmpty)
        XCTAssertEqual(listModel?.articleList.first?.headline, "title1")
    }

    func testResetData() {
        XCTAssertFalse(listModel!.articleList.isEmpty)
        listModel?.resetData()
        XCTAssertTrue(listModel!.articleList.isEmpty)
    }

    func testAppendNewsList() {
        listModel?.appendNewsList(newList: mockList)
        XCTAssertTrue(listModel!.articleList.count > mockList.count)
        XCTAssertEqual(listModel!.page, 1)
    }

    func testUpdateImage() {
        listModel?.updateImage(index: 1, image: UIImage.placeholderImage)
        XCTAssertTrue(listModel!.articleList[1].downloaded)
    }
}
