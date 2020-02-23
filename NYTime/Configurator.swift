//
//  Configurator.swift
//  NYTime
//
//  Created by Parth Dubal on 23/02/20.
//  Copyright © 2020 Parth Dubal. All rights reserved.
//

import UIKit
protocol Configurator {
    func build() -> UIViewController
}

struct NewsListConfigurator: Configurator {
    private var viewModel: NewsListViewModel
    init() {
        let apiConfig = ApiNetworkConfig(baseURL: URL(string: APIConstantKeys.baseURL)!,
                                         headers: [:],
                                         queryParameters: ["api-key": APIConstantKeys.APIKey])
        let networkSession = DefaultNetworkHandler(session: URLSession.shared)
        let networkService = DefaultNetworkService(config: apiConfig, networkSession: networkSession)
        let newsRepository = NYTimesRepository(session: networkService)
        viewModel = NewsListViewModelImpl(newsService: newsRepository)
    }

    func build() -> UIViewController {
        NewsListViewController(viewModel: viewModel)
    }
}
