//
//  NYTimesResult+Mapping.swift
//  NYTime
//
//  Created by Parth Dubal on 23/02/20.
//  Copyright © 2020 Parth Dubal. All rights reserved.
//

import Foundation

extension NYTimesResult {
    func toNewsListItem() -> [NewsListItem] {
        return result.compactMap { NewsListItem(newsItem: $0) }
    }
}

extension NewsListItem {
    init(newsItem: NYTimesItem) {
        title = newsItem.headline
        description = newsItem.description
        imageURL = newsItem.imageURL
        webURL = newsItem.webURL
        if let date = newsItem.publishDate {
            publishDate = "\(date)"
        } else {
            publishDate = ""
        }
    }
}
