//
//  NewsListViewModelTest.swift
//  NYTimeTests
//
//  Created by Parth Dubal on 23/02/20.
//  Copyright © 2020 Parth Dubal. All rights reserved.
//
@testable import NYTime
import XCTest

class NewsListViewModelTest: XCTestCase {
    class MockTableView: UITableView {
        override var indexPathsForVisibleRows: [IndexPath]? {
            return [IndexPath(row: 0, section: 0),
                    IndexPath(row: 1, section: 0),
                    IndexPath(row: 2, section: 0),
                    IndexPath(row: 3, section: 0),
                    IndexPath(row: 4, section: 0)]
        }
    }

    var viewModel: NewsListViewModelImpl!

    private func initViewModel(service: NewsServiceProvider) {
        viewModel = NewsListViewModelImpl(newsService: service)
    }

    func testSuccessReqeustNews() {
        let successService = MockSuccessNewsService(response: NewsListItem.buildMock())
        initViewModel(service: successService)

        XCTAssertTrue(viewModel.newsListItems.isEmpty)

        let expectation = self.expectation(description: "Loading News")

        viewModel.didUpdateService = { service in
            if service == .success {
                XCTAssertFalse(self.viewModel.newsListItems.isEmpty)
                self.viewModel.didUpdateService = nil
                expectation.fulfill()
            }
        }
        viewModel.searchNewsArticle(query: "singapore")
        wait(for: [expectation], timeout: 1.0)
    }

    func testShouldLoadmore() {
        let successService = MockSuccessNewsService(response: NewsListItem.buildMock())
        initViewModel(service: successService)
        viewModel.searchNewsArticle(query: "singapore")

        let shouldLoadMore = viewModel.shouldLoadmore(tableView: MockTableView(),
                                                      indexPath: IndexPath(row: 4, section: 0))
        XCTAssertTrue(shouldLoadMore)
    }

    func testSuccessLoadNextPageNews() {
        let successService = MockSuccessNewsService(response: NewsListItem.buildMock())
        initViewModel(service: successService)

        XCTAssertTrue(viewModel.newsListItems.isEmpty)
        viewModel.searchNewsArticle(query: "singapore")

        let expectation = self.expectation(description: "Loading nextpage News")
        viewModel.loadNextPageArticle()
        viewModel.didUpdateService = { service in
            if service == .success {
                let count = self.viewModel.newsListItems.count
                XCTAssertTrue(count > NewsListItem.buildMock().count)
                self.viewModel.didUpdateService = nil
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 2.0)
    }

    func testSuccessShouldLoadPhoto() {
        let successService = MockSuccessNewsService(response: NewsListItem.buildMock())
        initViewModel(service: successService)
        viewModel.searchNewsArticle(query: "singapore") // here loading data in viewmodel.

        let shouldLoadPhoto = viewModel.shouldLoadPhoto(tableView: MockTableView(),
                                                        indexPath: IndexPath(row: 4, section: 0))
        XCTAssertTrue(shouldLoadPhoto)
    }

    func testFailureShouldLoadPhoto() {
        let successService = MockSuccessNewsService(response: NewsListItem.buildMock())
        initViewModel(service: successService)
        let shouldLoadPhoto = viewModel.shouldLoadPhoto(tableView: MockTableView(),
                                                        indexPath: IndexPath(row: 5, section: 0))
        XCTAssertFalse(shouldLoadPhoto)
    }

    func testFailureRequsetNews() {
        let failureService = MockFailNewsService()
        initViewModel(service: failureService)

        let expectation = self.expectation(description: "Loading News")

        viewModel.didUpdateService = { service in
            if service == .error {
                XCTAssertTrue(self.viewModel.newsListItems.isEmpty)
                self.viewModel.didUpdateService = nil
                expectation.fulfill()
            }
        }
        viewModel.searchNewsArticle(query: "singapore")
        wait(for: [expectation], timeout: 1.0)
    }

    func testFailureShouldLoadmre() {
        let failureService = MockFailNewsService()
        initViewModel(service: failureService)

        viewModel.searchNewsArticle(query: "singapore")

        let shouldLoadMore = viewModel.shouldLoadmore(tableView: MockTableView(),
                                                      indexPath: IndexPath(row: 4, section: 0))
        XCTAssertFalse(shouldLoadMore)
    }
}
