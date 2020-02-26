//
//  NewsListViewModel.swift
//  NYTime
//
//  Created by Parth Dubal on 22/02/20.
//  Copyright © 2020 Parth Dubal. All rights reserved.
//

import UIKit

/// A type define current status for network service.
/// `initial` - initial status of service / no
/// `refresh` request for new service
/// `success` determine service is completed successfully
/// `loadmore` determinse service is for load more
/// ` error` when there is error in service
/// `errorLoadMore` determine error when trying for load more
enum ServiceStatus {
    case initial
    case refresh
    case success
    case loadmore
    case error
    case errorLoadMore
}

/// A template protocol for News list view-model
protocol NewsListViewModel {
    var newsListItems: [NewsListItem] { get }
    var didUpdateService: ((ServiceStatus) -> Void)? { get set }
    var notifyUpdates: (() -> Void)? { get set }
    func searchNewsArticle(query: String)
    func shouldLoadmore(tableView: UITableView, indexPath: IndexPath) -> Bool
    func loadNextPageArticle()
    func shouldLoadPhoto(tableView: UITableView, indexPath: IndexPath) -> Bool
    func loadPhoto(indexPath: IndexPath)
}

/// `NewsListViewModelImpl`implements `NewsListViewModel` services
final class NewsListViewModelImpl {
    /// Determine current status for services
    private var serviceStatus: ServiceStatus = .initial {
        didSet {
            notifyServiceStatus()
        }
    }

    /// keeping current query instace
    private var query: String = ""

    /// Internal model to keep reference for page & NewsListItem
    private var resultModel: NewsListModel = NewsListModel(page: 0, articleList: [])

    /// Notify updates for services change
    var didUpdateService: ((ServiceStatus) -> Void)?

    /// Notify updates for changes in  `resultmodel`
    var notifyUpdates: (() -> Void)?

    /// A `Cancellable` reference to previous news request
    private var articleRequest: Cancellable? {
        didSet {
            oldValue?.cancel()
        }
    }

    /// A  `Cancellable` reference to previous load more request.
    private var loadMoreArticleRequest: Cancellable? {
        didSet {
            oldValue?.cancel()
        }
    }

    private let newsService: NewsServiceProvider
    init(newsService: NewsServiceProvider) {
        self.newsService = newsService
    }

    deinit {
        articleRequest?.cancel()
        loadMoreArticleRequest?.cancel()
        didUpdateService = nil
        notifyUpdates = nil
    }
}

// MARK: - Notify handler sections.

private extension NewsListViewModelImpl {
    private func notifyServiceStatus() {
        DispatchQueue.main.async {
            self.didUpdateService?(self.serviceStatus)
        }
    }

    private func handleNextPageResponse(_ list: [NewsListItem]) {
        resultModel.appendNewsList(newList: list)
    }
}

// MARK: - NewsListViewModel implementation sections

extension NewsListViewModelImpl: NewsListViewModel {
    /// list of `NewsListItem`
    var newsListItems: [NewsListItem] {
        resultModel.articleList
    }

    /// Create request for search article based on query
    /// - Parameter query: A query to perform search for articles
    func searchNewsArticle(query: String) {
        loadMoreArticleRequest = nil // clear any previoud loadmore request.
        serviceStatus = .refresh // setting service status as loading
        self.query = query
        articleRequest = newsService.searchNewsArticle(query: query, page: 0) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(list):
                self.resultModel.resetData()
                self.resultModel.setArticleList(list: list)
                self.serviceStatus = .success
            case .failure:
                self.serviceStatus = .error
            }
        }
    }

    /// Validate load more request for articles in list
    ///
    /// Here we check indexPath for visible row in table and indexPath to check.
    /// We check current `serviceStatus`is not `.loadmore`. indexPath row is last news article item within visible paths.
    /// - Parameters:
    ///   - tableView: tableView to validate load more
    ///   - indexPath: indexPath to test for load more
    func shouldLoadmore(tableView: UITableView, indexPath: IndexPath) -> Bool {
        let visiblePath = Set(tableView.indexPathsForVisibleRows ?? [])
        let isLastRow = indexPath.row == newsListItems.count - 1
        let isNotLoadmore = serviceStatus != .loadmore
        return visiblePath.contains(indexPath) && isLastRow && isNotLoadmore
    }

    /// Initiat request for next page article list based on previosu `query`
    func loadNextPageArticle() {
        serviceStatus = .loadmore

        loadMoreArticleRequest = newsService.searchNewsArticle(query: query, page: resultModel.page + 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(list):
                self.handleNextPageResponse(list)
                self.serviceStatus = .success
            case .failure:
                self.serviceStatus = .errorLoadMore
            }
        }
    }

    /// Validate load photo request based on visible index path and passed indexPath.
    ///  Here we check downloaded status, imageURL exist and indexPath is visible in tableview.
    /// - Parameters:
    ///   - tableView: tableView to validate load photo
    ///   - indexPath: indexPath to fetch photo
    func shouldLoadPhoto(tableView: UITableView, indexPath: IndexPath) -> Bool {
        guard newsListItems.count > indexPath.row else {
            return false
        }
        let visiblePath = Set(tableView.indexPathsForVisibleRows ?? [])
        let newsItem = newsListItems[indexPath.row]
        return visiblePath.contains(indexPath) && !newsItem.downloaded && !newsItem.imageURL.isEmpty
    }

    /// Initial load photo request for indexPath
    /// - Parameter indexPath: indexPath to reqeust photo
    func loadPhoto(indexPath: IndexPath) {
        let imageURL = newsListItems[indexPath.item].imageURL
        newsService.downloadPhotos(imagePath: imageURL) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(image):
                self.resultModel.updateImage(index: indexPath.row, image: image)
                self.notifyUpdates?()
            case .failure:
                break
            }
        }
    }
}
