//
//  NYTimesImageService.swift
//  NYTime
//
//  Created by Parth Dubal on 24/02/20.
//  Copyright © 2020 Parth Dubal. All rights reserved.
//

import Foundation

final class ImageDownloaderService {
    private let config: NetworkConfigurable
    private let networkSession: NetworkSession
    var imageDownloadOperation = OperationQueue()
    init(config: NetworkConfigurable, networkSession: NetworkSession) {
        self.config = config
        self.networkSession = networkSession
    }
}

extension ImageDownloaderService: NetworkService {
    
    /// Check for existing `ImageOperation` for url
    /// - Parameter imageUrl: url to validate for existing operation
    private func getImageOperation(imageUrl: URL) -> ImageOperation? {
        let operations = (imageDownloadOperation.operations as? [ImageOperation])?.filter { $0.imageUrl.absoluteString == imageUrl.absoluteString && $0.isFinished == false && $0.isExecuting == true }
        return operations?.first
    }

    func request(endpoint: APIEndPoint,
                 completion: @escaping CompletionHandler) -> NetworkCancellable? {
        do {
            let imageUrl = try endpoint.url(with: config)

            // validating existing image operations.
            if let operation = getImageOperation(imageUrl: imageUrl) {
                operation.queuePriority = .high
                return nil
            }

            let downloadOperation = ImageOperation(imageUrl: imageUrl, urlSession: networkSession)

            downloadOperation.downloadHandler = { data, error in

                if let resultError = error {
                    completion(.failure(.generic(resultError)))
                    return
                }
                completion(.success(data))
            }
            imageDownloadOperation.addOperation(downloadOperation)
        } catch {
            completion(.failure(.urlGeneration))
        }
        return nil
    }
}
