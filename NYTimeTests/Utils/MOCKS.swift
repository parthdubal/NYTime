//
//  MOCKS.swift
//  NYTimeTests
//
//  Created by Parth Dubal on 23/02/20.
//  Copyright © 2020 Parth Dubal. All rights reserved.
//

import UIKit

enum UITestRunner: String {
    case successRunningUITest
    case failureRunningUITest
    case noneRuninningUITest
}

extension ProcessInfo {
    func isRunningUITest() -> UITestRunner {
        if arguments.contains(UITestRunner.successRunningUITest.rawValue) {
            return UITestRunner.successRunningUITest
        }

        if arguments.contains(UITestRunner.failureRunningUITest.rawValue) {
            return UITestRunner.failureRunningUITest
        }
        return .noneRuninningUITest
    }
}

// Implement below for mocks & stub.
struct MockSuccessNewListConfigurator: Configurator {
    private var viewModel: NewsListViewModel
    init() {
        let apiConfig = ApiNetworkConfig(baseURL: URL(string: APIConstantKeys.baseURL)!,
                                         headers: [:],
                                         queryParameters: ["api-key": APIConstantKeys.APIKey])
        let imageApiConfig = ApiNetworkConfig(baseURL: URL(string: APIConstantKeys.imageBaseURL)!)

        let networkSession = SuccessNetworkSession(data: NYTimesResult.buildMockData())
        let networkService = DefaultNetworkService(config: apiConfig, networkSession: networkSession)

        let imageService = ImageDownloaderService(config: imageApiConfig, networkSession: networkSession)
        let data = UIImage(named: "placeholder")?.jpegData(compressionQuality: 1.0) ?? Data()

        let newsRepository = NYTimesRepository(newsService: networkService, imageService: imageService, noImageData: data)
        viewModel = NewsListViewModelImpl(newsService: newsRepository)
    }

    func build() -> UIViewController {
        NewsListViewController(viewModel: viewModel)
    }
}

struct MockFailureNewListConfigurator: Configurator {
    private var viewModel: NewsListViewModel
    init() {
        let apiConfig = ApiNetworkConfig(baseURL: URL(string: APIConstantKeys.baseURL)!,
                                         headers: [:],
                                         queryParameters: ["api-key": APIConstantKeys.APIKey])
        let imageApiConfig = ApiNetworkConfig(baseURL: URL(string: APIConstantKeys.imageBaseURL)!)
        let networkSession = FailureNetworkSession()
        let networkService = DefaultNetworkService(config: apiConfig, networkSession: networkSession)

        let imageService = ImageDownloaderService(config: imageApiConfig, networkSession: networkSession)
        let data = UIImage(named: "placeholder")?.jpegData(compressionQuality: 1.0) ?? Data()

        let newsRepository = NYTimesRepository(newsService: networkService, imageService: imageService, noImageData: data)
        viewModel = NewsListViewModelImpl(newsService: newsRepository)
    }

    func build() -> UIViewController {
        NewsListViewController(viewModel: viewModel)
    }
}

final class SuccessMockNetworkService: NetworkService {
    private(set) var requestDidCall = false
    let data: Data
    init(data: Data) {
        self.data = data
    }

    func request(endpoint _: APIEndPoint, completion: @escaping CompletionHandler) -> NetworkCancellable? {
        requestDidCall = true
        completion(.success(data))
        return nil
    }
}

final class FailureMockNetworkService: NetworkService {
    private(set) var requestDidCall = false
    init() {}

    func request(endpoint _: APIEndPoint, completion: @escaping CompletionHandler) -> NetworkCancellable? {
        requestDidCall = true
        completion(.failure(.urlGeneration))
        return nil
    }
}

extension APIEndPointProvider {
    static func mockAPIPoint(path: String,
                             isFullPath: Bool,
                             method: HTTPMethod,
                             query: [String: Any],
                             header: [String: String]) -> APIEndPoint {
        return APIEndPointProvider(path: path,
                                   isFullPath: isFullPath,
                                   method: method,
                                   queryParameters: query,
                                   headerParamaters: header)
    }
}

final class MockNetworkCanallable: NetworkCancellable {
    private(set) var cancelCalled: Bool = false
    func cancel() {
        cancelCalled = true
    }
}

final class SuccessNetworkSession: NetworkSession {
    private(set) var requestDidCall = false
    let data: Data
    init(data: Data) {
        self.data = data
    }

    func request(_: URLRequest, completion: @escaping CompletionHandler) -> NetworkCancellable {
        requestDidCall = true
        completion(data, nil, nil)
        return MockNetworkCanallable()
    }
}

final class FailureNetworkSession: NetworkSession {
    private(set) var requestDidCall = false
    func request(_: URLRequest, completion: @escaping CompletionHandler) -> NetworkCancellable {
        requestDidCall = true
        completion(nil, nil, NetworkError.error(statusCode: 404, data: nil))
        return MockNetworkCanallable()
    }
}

extension NewsListItem {
    static func buildMock() -> [NewsListItem] {
        let item1 = NewsListItem(title: "title1",
                                 imageUrl: "/image/1.png",
                                 description: "testdescription 1",
                                 publishDate: "21/12/2020")
        let item2 = NewsListItem(title: "title2",
                                 imageUrl: "/image/2.png",
                                 description: "testdescription 2",
                                 publishDate: "21/12/2020")
        let item3 = NewsListItem(title: "title3",
                                 imageUrl: "/image/3.png",
                                 description: "testdescription 3",
                                 publishDate: "21/12/2020")
        let item4 = NewsListItem(title: "title4",
                                 imageUrl: "/image/4.png",
                                 description: "testdescription 4",
                                 publishDate: "21/12/2020")
        let item5 = NewsListItem(title: "title5",
                                 imageUrl: "/image/52.png",
                                 description: "testdescription 5",
                                 publishDate: "21/12/2020")
        return [item1,
                item2,
                item3,
                item4,
                item5]
    }
}

final class MockSuccessNewsService: NewsListRepository, PhotoRepositoryService {
    private(set) var requestCall: Bool = false
    private(set) var requestImageCall: Bool = false
    private(set) var query: String = ""
    private(set) var page: Int = 0

    let response: [NewsListItem]
    init(response: [NewsListItem]) {
        self.response = response
    }

    func requestNewsList(query: String,
                         page: Int,
                         completion: @escaping (Result<[NewsListItem], Error>) -> Void) -> Cancellable? {
        requestCall = true
        self.query = query
        self.page = page
        completion(.success(response))
        return nil
    }

    func downloadPhotos(imagePath _: String, indexPath: IndexPath?, completionHandler: @escaping (Result<(UIImage?, IndexPath?), Error>) -> Void) -> Cancellable? {
        requestImageCall = true
        completionHandler(.success((nil, indexPath)))
        return nil
    }
}

final class MockFailNewsService: NewsListRepository, PhotoRepositoryService {
    private(set) var requestImageCall: Bool = false
    private(set) var requestCall: Bool = false
    private(set) var query: String = ""
    private(set) var page: Int = 0

    func requestNewsList(query: String,
                         page: Int,
                         completion: @escaping (Result<[NewsListItem], Error>) -> Void) -> Cancellable? {
        self.query = query
        self.page = page
        requestCall = true
        completion(.failure(NetworkError.urlGeneration))
        return nil
    }

    func downloadPhotos(imagePath _: String, indexPath _: IndexPath?, completionHandler: @escaping (Result<(UIImage?, IndexPath?), Error>) -> Void) -> Cancellable? {
        requestImageCall = true
        completionHandler(.failure(NetworkError.urlGeneration))
        return nil
    }
}

extension NYTimesResult {
    static func buildMockData() -> Data {
        let data = try? Data(contentsOf: URL(fileURLWithPath:
            Bundle.helperBundle.mockNews))
        return data ?? Data()
    }
}
