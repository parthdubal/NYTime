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
    init(session: NetworkService) {
        service = session
    }
}

extension NYTimesRepository: NewsListRepository {
    func requestNewsList(query: String,
                         page: Int,
                         completion: @escaping (Result<[NewsListItem], Error>) -> Void) -> Cancellable? {
        let task = service.request(endpoint: newsAPIPoint(query: query, page: page)) { result in

            switch result {
            case let .success(data):
                if let dataObject = data {
                    let decoder = JSONDecoder()
                    guard let response = try? decoder.decode(NYTimesResult.self, from: dataObject) else {
                        completion(.failure(NetworkError.urlGeneration))
                        return
                    }
                    DispatchQueue.main.async {
                        completion(.success(response.toNewsListItem()))
                    }
                }

            case let .failure(error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        return RepositoryTask(networkTask: task)
    }
}

private extension NYTimesRepository {
    func newsAPIPoint(query: String, page: Int) -> APIEndPoint {
        return APIEndPointProvider(path: "svc/search/v2/articlesearch.json",
                                   queryParameters: [
                                       "q": query,
                                       "page": "\(page)",
                                   ])
    }
}
