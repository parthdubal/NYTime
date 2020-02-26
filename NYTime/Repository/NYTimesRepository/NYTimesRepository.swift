//
//  NYTimesRepository.swift
//  NYTime
//
//  Created by Parth Dubal on 23/02/20.
//  Copyright © 2020 Parth Dubal. All rights reserved.
//

import UIKit

/// NYTimes API Points used in services
enum NYTImesAPIPoints {
    /// searc article api path point
    case searchArticle(query: String, page: Int)

    // photo download api path point
    case photoService(imagePath: String)

    /// Generate `APIEndPoint` based on current api path case  of `NYTimesAPIPoints`
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

/// Base service class for NYTimes API services.
/// Integrates API service related to https://developer.nytimes.com/
/**
 `NYTimesRepository`initialize with `NetworkService` instance for news & image services.
 Both service are seprate network services instace.
 */
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

// MARK: - implements SearchNewsArticleRepository protocol

extension NYTimesRepository: SearchNewsArticleRepository {
    /// Request for article search on New york times  api portal
    /// - Parameters:
    ///   - query: query for article search
    ///   - page: page for search result
    ///   - completion: Response handle for the article news list
    func searchNewsArticle(query: String,
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

// MARK: - implements PhotoRepositoryService protocol

extension NYTimesRepository: PhotoRepositoryService {
    /// Download Article images from server
    /// - Parameters:
    ///   - imagePath: article imagePath to load
    ///   - completionHandler: Response handle for the image load.
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
