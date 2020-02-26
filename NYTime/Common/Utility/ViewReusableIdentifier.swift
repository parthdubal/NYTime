//
//  ViewReusableIdentifier.swift
//  NYTime
//
//  Created by Parth Dubal on 22/02/20.
//  Copyright © 2020 Parth Dubal. All rights reserved.
//

import Foundation

/// Reusable view identifier protocol.
///
/// `ViewReusableIdentifier` provide default implementation for `reusableIdentifier`.
protocol ViewReusableIdentifier: class {
    static var reusableIdentifier: String { get }
}

extension ViewReusableIdentifier {
    /// Reusable Identifier value for a view.
    static var reusableIdentifier: String {
        return NSStringFromClass(self)
    }
}
