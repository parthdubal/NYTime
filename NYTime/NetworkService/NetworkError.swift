//
//  NetworkError.swift
//  NYTime
//
//  Created by Parth Dubal on 23/02/20.
//  Copyright © 2020 Parth Dubal. All rights reserved.
//

import Foundation

/// `NetowrkError` Error type of enum
///
/// It can be `generic`, `urlGeneration`, specific status/data error case.
enum NetworkError: Error {
    case error(statusCode: Int, data: Data?)
    case generic(Error)
    case urlGeneration
}
