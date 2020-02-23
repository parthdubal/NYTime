//
//  Test+Utils.swift
//  GrabAssessmentTests
//
//  Created by Parth Dubal on 18/01/20.
//  Copyright © 2020 Parth Dubal. All rights reserved.
//

import Foundation

extension String {
    func objectFromPath<T: Decodable>(object: T.Type) -> T? {
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: self)) else {
            return nil
        }
        let decoder = JSONDecoder()
        do {
            let resultObject = try decoder.decode(object, from: data)
            return resultObject
        } catch {
            print("parsing error: \(error)")
        }
        return nil
    }
}
