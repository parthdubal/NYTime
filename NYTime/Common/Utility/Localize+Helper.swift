//
//  Localize+Helper.swift
//  NYTime
//
//  Created by Parth Dubal on 22/02/20.
//  Copyright © 2020 Parth Dubal. All rights reserved.
//

import Foundation

/// localize helper function
/// - Parameter key: localize key to get localize text.
func localize(key: String) -> String {
    return NSLocalizedString(key, comment: "")
}
