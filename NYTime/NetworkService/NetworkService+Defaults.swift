//
//  NetworkService+Defaults.swift
//  NYTime
//
//  Created by Parth Dubal on 23/02/20.
//  Copyright © 2020 Parth Dubal. All rights reserved.
//

import Foundation

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
                    completion(.failure(error))
                } else {
                    completion(.success(data))
                }
            }
        } catch {
            completion(.failure(.urlGeneration))
            return nil
        }
    }
}
