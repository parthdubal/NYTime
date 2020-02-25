//
//  NetworkConfig.swift
//  NYTime
//
//  Created by Parth Dubal on 23/02/20.
//  Copyright © 2020 Parth Dubal. All rights reserved.
//

import Foundation

/// A type of network configurable template for Network services usage.
///
/// It define `baseURL`, `headers`, `queryParameters` that passes with each request.
protocol NetworkConfigurable {
    var baseURL: URL { get }
    var headers: [String: String] { get }
    var queryParameters: [String: String] { get }
}

/// Helper model  for `NetworkConfigurable`protocol.
struct ApiNetworkConfig: NetworkConfigurable {
    let baseURL: URL
    let headers: [String: String]
    let queryParameters: [String: String]

    init(baseURL: URL,
         headers: [String: String] = [:],
         queryParameters: [String: String] = [:]) {
        self.baseURL = baseURL
        self.headers = headers
        self.queryParameters = queryParameters
    }
}
