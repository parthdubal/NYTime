//
//  Bundle+Helper.swift
//  GrabAssessmentTests
//
//  Created by Parth Dubal on 18/01/20.
//  Copyright © 2020 Parth Dubal. All rights reserved.
//

import Foundation

private class Maker {}

extension Bundle {
    static let helperBundle = Bundle(for: Maker.self)

    var mockNews: String {
        retriveFile(name: "Mock_News", type: "json")
    }

    private func retriveFile(name: String, type: String) -> String {
        let path = self.path(forResource: name, ofType: type)
        return path ?? ""
    }
}
