//
//  NewsListViewModel.swift
//  NYTime
//
//  Created by Parth Dubal on 22/02/20.
//  Copyright © 2020 Parth Dubal. All rights reserved.
//

import Foundation

enum ServiceStatus {
    case initial
    case loading
    case successLoading
    case loadingNextPage
    case error
    case errorNextPage
}

protocol NewsListViewModel {
    var newsListItems: [NewsListItem] { get }
    var didUpdateService: ((ServiceStatus) -> Void)? { get set }
    func requestNews(query: String)
    func loadNextPage()
}

final class NewsListViewModelImpl {
    var serviceStatus: ServiceStatus = .initial
    var resultModel: NewsListModel = NewsListModel(page: 0, list: [])
    var didUpdateService: ((ServiceStatus) -> Void)?
    
    init() {
        
    }
    
    private func notifyServiceStatus() {
        DispatchQueue.main.async {
            self.didUpdateService?(self.serviceStatus)
        }
    }
}

extension NewsListViewModelImpl: NewsListViewModel {
    var newsListItems: [NewsListItem] {
        resultModel.list
    }
    
    func requestNews(query: String) {
        
    }
    
    func loadNextPage() {
        
    }
}
