//
//  NewsListModel.swift
//  NYTime
//
//  Created by Parth Dubal on 22/02/20.
//  Copyright © 2020 Parth Dubal. All rights reserved.
//

import Foundation
import UIKit

/// ViewModel  structure of NewsListItem and page
struct NewsListModel {
    var page: Int = 0
    var list: [NewsListItem] = []

    mutating func resetData() {
        page = 0
        list.removeAll()
    }

    mutating func appendNewsList(newList: [NewsListItem]) {
        list += newList
        page += 1
    }

    mutating func updateImage(index: Int, image: UIImage?) {
        guard list.count > index else {
            return
        }
        list[index].newsImage = image ?? UIImage.placeholderImage
        list[index].downloaded = true
    }
}

struct NewsListItem {
    let headline: String
    let description: String
    let publishDate: String
    let imageURL: String
    let webURL: String
    var newsImage: UIImage? = UIImage.placeholderImage
    fileprivate(set) var downloaded = false

    init(headline: String,
         imageUrl: String,
         description: String,
         publishDate: String,
         webURL: String = "") {
        self.headline = headline
        imageURL = imageUrl
        self.description = description
        self.publishDate = publishDate
        self.webURL = webURL
    }
}

extension NewsListItem: NewsListCellItemModel {}
