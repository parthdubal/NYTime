//
//  NYTimesRepository.swift
//  NYTime
//
//  Created by Parth Dubal on 23/02/20.
//  Copyright © 2020 Parth Dubal. All rights reserved.
//

import UIKit

final class NYTimesRepository {
    var newsService: NetworkService
    var imageService: NetworkService

    var noImageData: Data

    init(newsService: NetworkService,
         imageService: NetworkService,
         noImageData: Data) {
        self.newsService = newsService
        self.imageService = imageService
        self.noImageData = noImageData
    }
}

extension NYTimesRepository: NewsListRepository {
    func requestNewsList(query: String,
                         page: Int,
                         completion: @escaping (Result<[NewsListItem], Error>) -> Void) -> Cancellable? {
        let task = newsService.request(endpoint: newsAPIPoint(query: query, page: page)) { result in

            switch result {
            case let .success(data):
                if let dataObject = data {
                    let decoder = JSONDecoder()
                    guard let response = try? decoder.decode(NYTimesResult.self, from: dataObject) else {
                        completion(.failure(NetworkError.urlGeneration))
                        return
                    }
                    let newsListItems = response.toNewsListItem()
                    DispatchQueue.main.async {
                        completion(.success(newsListItems))
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

extension NYTimesRepository: PhotoRepositoryService {
    func downloadPhotos(imagePath: String,
                        completionHandler: @escaping (Result<UIImage?, Error>) -> Void) -> Cancellable? {
        let task = imageService.request(endpoint: photoServicePoint(imagePath: imagePath)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(data):
                let image = UIImage(data: data ?? self.noImageData)
                DispatchQueue.main.async {
                    completionHandler(.success(image))
                }
            case let .failure(error):
                DispatchQueue.main.async {
                    completionHandler(.failure(error))
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
                                       "sort": "newest",
                                   ])
    }

    func photoServicePoint(imagePath: String) -> APIEndPoint {
        return APIEndPointProvider(path: imagePath,
                                   isFullPath: false)
    }
}
