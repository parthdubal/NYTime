//
//  NetworkService.swift
//  NYTime
//
//  Created by Parth Dubal on 23/02/20.
//  Copyright © 2020 Parth Dubal. All rights reserved.
//

import Foundation

protocol NetworkCancellable {
    func cancel()
}

extension URLSessionTask: NetworkCancellable {}

protocol NetworkService {
    typealias CompletionHandler = (Result<Data?, NetworkError>) -> Void
    func request(endpoint: APIEndPoint, completion: @escaping CompletionHandler) -> NetworkCancellable?
}

protocol NetworkSession {
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    func request(_ request: URLRequest,
                 completion: @escaping CompletionHandler) -> NetworkCancellable
}

/// Default network handler with session
final class DefaultNetworkHandler {
    let session: URLSession
    init(session: URLSession) {
        self.session = session
    }
}

extension DefaultNetworkHandler: NetworkSession {
    func request(_ request: URLRequest, completion: @escaping CompletionHandler) -> NetworkCancellable {
        let task = session.dataTask(with: request, completionHandler: completion)
        task.resume()
        return task
    }
}

final class DefaultNetworkService {
    private let config: NetworkConfigurable
    private let networkSession: NetworkSession
    init(config: NetworkConfigurable, networkSession: NetworkSession) {
        self.config = config
        self.networkSession = networkSession
    }
}

extension DefaultNetworkService: NetworkService {
    func request(endpoint: APIEndPoint, completion: @escaping CompletionHandler) -> NetworkCancellable? {
        do {
            let urlRequest = try endpoint.urlRequest(config)
            return networkSession.request(urlRequest) { data, response, requestError in
                if let requestError = requestError {
                    var error: NetworkError
                    if let response = response as? HTTPURLResponse {
                        error = .error(statusCode: response.statusCode, data: data)
                    } else {
                        error = NetworkError.generic(requestError)
                    }
                    Logger.print(error)
                    completion(.failure(error))
                } else {
                    completion(.success(data))
                }
            }
        } catch {
            completion(.failure(.urlGeneration))
            return nil
        }

//        return self.networkSession.request(endpoint: endpoint) { result in
//            switch result {
//            case .success(let data):
//                let result: Result<T, Error> = self.decode(data: data, decoder: endpoint.responseDecoder)
//                DispatchQueue.main.async { return completion(result) }
//            case .failure(let error):
//                self.errorLogger.log(error: error)
//                let error = self.resolve(networkError: error)
//                DispatchQueue.main.async { return completion(.failure(error)) }
//            }
//        }
    }
}
