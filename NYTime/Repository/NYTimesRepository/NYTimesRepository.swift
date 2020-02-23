//
//  NYTimesRepository.swift
//  NYTime
//
//  Created by Parth Dubal on 23/02/20.
//  Copyright © 2020 Parth Dubal. All rights reserved.
//

import Foundation

final class NYTimesRepository {
    var service: NetworkService
    init(session:NetworkService) {
        self.service = session
    }
}

extension NYTimesRepository: NewsListRepository {
    func requestNewsList(query: String,
                         page: Int,
                         completion: @escaping (Result<[NewsListItem], Error>) -> Void) -> Cancellable? {
        
        return RepositoryTask(networkTask: nil)
//        return service.request(endpoint: <#T##APIEndPoint#>, completion: <#T##(Result<Data?, NetworkError>) -> Void#>)
    }
}
