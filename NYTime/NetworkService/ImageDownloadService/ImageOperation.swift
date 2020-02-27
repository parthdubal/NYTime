//
//  ImageOperation.swift
//  NYTime
//
//  Created by Parth Dubal on 24/02/20.
//  Copyright © 2020 Parth Dubal. All rights reserved.
//

import Foundation
import UIKit

class ImageOperation: Operation {
    typealias CompletionHandler = ((_ data: Data?, _ error: Error?) -> Void)
    var downloadHandler: CompletionHandler?
    let imageUrl: URL
    let urlSession: NetworkSession

    required init(imageUrl: URL,
                  urlSession: NetworkSession) {
        self.imageUrl = imageUrl
        self.urlSession = urlSession
    }

    override var isAsynchronous: Bool {
        return true
    }

    private var _executing = false {
        willSet {
            willChangeValue(forKey: "isExecuting")
        }
        didSet {
            didChangeValue(forKey: "isExecuting")
        }
    }

    override var isExecuting: Bool {
        return _executing
    }

    private var _finished = false {
        willSet {
            willChangeValue(forKey: "isFinished")
        }

        didSet {
            didChangeValue(forKey: "isFinished")
        }
    }

    override var isFinished: Bool {
        return _finished
    }

    func executing(_ executing: Bool) {
        _executing = executing
    }

    func finish(_ finished: Bool) {
        _finished = finished
    }

    override func main() {
        guard isCancelled == false else {
            finish(true)
            return
        }
        downloadImageFromUrl()
    }

    private func downloadImageFromUrl() {
        executing(true)
        _ = urlSession.request(URLRequest(url: imageUrl)) { [weak self] data, _, error in
            guard let self = self else { return }
            self.downloadHandler?(data, error)
            self.finish(true)
            self.executing(false)
        }
    }

    deinit {
        downloadHandler = nil
    }
}
