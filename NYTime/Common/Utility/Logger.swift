//
//  Logger.swift
//  NYTime
//
//  Created by Parth Dubal on 23/02/20.
//  Copyright © 2020 Parth Dubal. All rights reserved.
//

import Foundation

protocol LogService {
    static func print(_ items: Any...)
}

struct Logger: LogService {
    private static var activeLogService: LogService = DefaultDebugLogger()

    private init() {}
    static func print(_ items: Any...) {
        type(of: activeLogService).print(items)
    }

    static func setLoggerService(_ service: LogService) {
        activeLogService = service
    }
}

private struct DefaultDebugLogger: LogService {
    static func print(_ items: Any...) {
        #if DEBUG
            Swift.print(items)
        #endif
    }
}
