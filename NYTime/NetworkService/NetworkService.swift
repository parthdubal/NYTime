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
    func request(endpoint: APIEndPoint,
                 completion: @escaping CompletionHandler) -> NetworkCancellable?
}

protocol NetworkSession {
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    func request(_ request: URLRequest,
                 completion: @escaping CompletionHandler) -> NetworkCancellable
}
