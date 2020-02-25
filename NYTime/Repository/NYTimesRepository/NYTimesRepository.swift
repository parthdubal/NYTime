//
//  NYTimesRepository.swift
//  NYTime
//
//  Created by Parth Dubal on 23/02/20.
//  Copyright © 2020 Parth Dubal. All rights reserved.
//

import UIKit

enum NYTImesAPIPoints {
    case searchArticle(query: String, page: Int)
    case photoService(imagePath: String)

    func toAPIEndPoint() -> APIEndPoint {
        switch self {
        case let .searchArticle(query, page):
            return APIEndPointProvider(path: "svc/search/v2/articlesearch.json", queryParameters: [
                "q": query,
                "page": "\(page)",
                "sort": "newest",
            ])
        case let .photoService(imagePath):
            return APIEndPointProvider(path: imagePath,
                                       isFullPath: false)
        }
    }
}

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
        let apiPoint = NYTImesAPIPoints.searchArticle(query: query, page: page).toAPIEndPoint()
        let task = newsService.request(endpoint: apiPoint) { result in

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
        let apiPoint = NYTImesAPIPoints.photoService(imagePath: imagePath).toAPIEndPoint()
        let task = imageService.request(endpoint: apiPoint) { [weak self] result in
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
