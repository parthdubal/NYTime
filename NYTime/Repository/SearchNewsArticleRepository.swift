//
//  SearchNewsArticleRepository.swift
//  NYTime
//
//  Created by Parth Dubal on 23/02/20.
//  Copyright © 2020 Parth Dubal. All rights reserved.
//

import Foundation

/// Base `SearchNewsArticleRepository` template for loading news list.
protocol SearchNewsArticleRepository {
    @discardableResult
    func searchNewsArticle(query: String,
                           page: Int,
                           completion: @escaping (Result<[NewsListItem], Error>) -> Void) -> Cancellable?
}
