//
//  NewsListViewModel.swift
//  NYTime
//
//  Created by Parth Dubal on 22/02/20.
//  Copyright © 2020 Parth Dubal. All rights reserved.
//

import UIKit

enum ServiceStatus {
    case initial
    case refresh
    case success
    case loadmore
    case error
    case errorLoadMore
}

protocol NewsListViewModel {
    var newsListItems: [NewsListItem] { get }
    var didUpdateService: ((ServiceStatus) -> Void)? { get set }
    func requestNews(query: String)
    func loadNextNewsPage()
    func shouldLoadmore(tableView: UITableView, indexPath: IndexPath) -> Bool
}

final class NewsListViewModelImpl {
    private var serviceStatus: ServiceStatus = .initial {
        didSet {
            notifyServiceStatus()
        }
    }

    private var query: String = ""
    private var resultModel: NewsListModel = NewsListModel(page: 0, list: [])

    var didUpdateService: ((ServiceStatus) -> Void)?

    private var newRequest: Cancellable? {
        didSet {
            oldValue?.cancel()
        }
    }

    private var loadmoreRequest: Cancellable? {
        didSet {
            oldValue?.cancel()
        }
    }

    private let newsService: NewsListRepository
    init(newsService: NewsListRepository) {
        self.newsService = newsService
    }
}

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

extension NewsListViewModelImpl: NewsListViewModel {
    var newsListItems: [NewsListItem] {
        resultModel.list
    }

    func requestNews(query: String) {
        loadmoreRequest = nil // clear any previoud loadmore request.
        serviceStatus = .refresh // setting service status as loading
        self.query = query
        newRequest = newsService.requestNewsList(query: query, page: 0) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(list):
                self.resultModel.resetData()
                self.resultModel.list = list
                self.serviceStatus = .success
            case .failure:
                self.serviceStatus = .error
            }
        }
    }

    func loadNextNewsPage() {
        serviceStatus = .loadmore
        loadmoreRequest = newsService.requestNewsList(query: query, page: resultModel.page + 1) { [weak self] result in
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

    func shouldLoadmore(tableView: UITableView, indexPath: IndexPath) -> Bool {
        let visiblePath = Set(tableView.indexPathsForVisibleRows ?? [])
        let isLastRow = indexPath.row == newsListItems.count - 1
        let isNotLoadmore = serviceStatus != .loadmore
        return visiblePath.contains(indexPath) && isLastRow && isNotLoadmore
    }
}
