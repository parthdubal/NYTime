//
//  PhotoRepositoryService.swift
//  NYTime
//
//  Created by Parth Dubal on 23/02/20.
//  Copyright © 2020 Parth Dubal. All rights reserved.
//

import Foundation

protocol PhotoRepositoryService {
    @discardableResult
    func downloadPhotos(url: URL?,
                        indexPath: IndexPath?,
                        completionHandler: @escaping (Result<Data, Error>) -> Void) -> Cancellable?
}
