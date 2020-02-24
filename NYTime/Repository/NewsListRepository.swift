//
//  NewsListRepository.swift
//  NYTime
//
//  Created by Parth Dubal on 23/02/20.
//  Copyright © 2020 Parth Dubal. All rights reserved.
//

import Foundation

protocol NewsListRepository {
    @discardableResult
    func requestNewsList(query: String,
                         page: Int,
                         completion: @escaping (Result<[NewsListItem], Error>) -> Void) -> Cancellable?
}
