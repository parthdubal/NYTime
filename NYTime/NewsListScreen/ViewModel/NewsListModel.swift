//
//  NewsListModel.swift
//  NYTime
//
//  Created by Parth Dubal on 22/02/20.
//  Copyright © 2020 Parth Dubal. All rights reserved.
//

import Foundation
import UIKit

struct NewsListModel {
    var page: Int = 0
    var list: [NewsListItem] = []
    
    mutating func resetData() {
        page = 0
        list.removeAll()
    }
}

struct NewsListItem {
    let title: String
    let description: String
    let imageUrl: String
    let publishDate: String
    
    var image: UIImage? = UIImage(named: "placeholder")
    
    init(title:String,
         imageUrl: String,
         description: String,
         publishDate: String) {
        
        self.title = title
        self.imageUrl = imageUrl
        self.description = description
        self.publishDate = publishDate
    }
}
