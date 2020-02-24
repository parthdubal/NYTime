//
//  PhotoRepositoryService.swift
//  NYTime
//
//  Created by Parth Dubal on 23/02/20.
//  Copyright © 2020 Parth Dubal. All rights reserved.
//

import UIKit

protocol PhotoRepositoryService {
    @discardableResult
    func downloadPhotos(imagePath: String,
                        completionHandler: @escaping (Result<UIImage?, Error>) -> Void) -> Cancellable?
}
