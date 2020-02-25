//
//  NYTimesResult+Mapping.swift
//  NYTime
//
//  Created by Parth Dubal on 23/02/20.
//  Copyright © 2020 Parth Dubal. All rights reserved.
//

import Foundation

extension NYTimesResult {
    /// Mapping `NYTimesItemt` list to `NewsListItem` list view model
    func toNewsListItem() -> [NewsListItem] {
        return result.compactMap(NewsListItem.init)
    }
}

extension NewsListItem {
    /// helper init to convert model into `NewsListItem`
    /// - Parameter newsItem: `NYTimesItem` codable model search arcticle api.
    fileprivate init(newsItem: NYTimesItem) {
        headline = newsItem.headline
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
