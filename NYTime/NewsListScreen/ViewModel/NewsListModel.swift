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
    private(set) var page: Int = 0
    private(set) var articleList: [NewsListItem] = []

    mutating func resetData() {
        page = 0
        articleList.removeAll()
    }

    /// Here we replace existing article list with new list
    /// - Parameter list: It is new list of articles.
    mutating func setArticleList(list: [NewsListItem]) {
        articleList = list
    }

    /// Added new news article list to existing  news list.
    ///
    /// This each new list is consider as new page. This should called when there is update for pagination reponse
    /// - Parameter newList: new list of news article.
    mutating func appendNewsList(newList: [NewsListItem]) {
        articleList += newList
        page += 1
    }

    /// Here we update image information of article.
    /// If image  nil. it sets default placeholder image
    /// - Parameters:
    ///   - index: index to update image
    ///   - image: image referece to update.
    mutating func updateImage(index: Int, image: UIImage?) {
        guard articleList.count > index else {
            return
        }
        articleList[index].newsImage = image ?? UIImage.placeholderImage
        articleList[index].downloaded = true
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
