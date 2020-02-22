//
//  NewsListItemCell.swift
//  NYTime
//
//  Created by Parth Dubal on 22/02/20.
//  Copyright © 2020 Parth Dubal. All rights reserved.
//

import UIKit

class NewsListItemCell: UITableViewCell {
    var item: NewsListItem? {
        didSet{
            updateViewData()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textLabel?.text = nil
        detailTextLabel?.text = nil
        imageView?.image = nil
    }
}
private extension NewsListItemCell {
    private func commonInit() {
        selectionStyle = .none
    }
    
    private func updateViewData()  {
        textLabel?.text = item?.title
        detailTextLabel?.text = item?.description
        imageView?.image = item?.image
    }
}

extension NewsListItemCell: ViewReusableIdentifier { }
