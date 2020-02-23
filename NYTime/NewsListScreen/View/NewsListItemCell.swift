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
        didSet {
            updateViewData()
        }
    }

    override init(style _: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView?.image = nil
    }
}

private extension NewsListItemCell {
    private func commonInit() {
        selectionStyle = .none
        textLabel?.numberOfLines = 0
        detailTextLabel?.numberOfLines = 0
    }

    private func updateViewData() {
        textLabel?.text = item?.title
        detailTextLabel?.text = item?.description
        imageView?.image = item?.image
    }
}

extension NewsListItemCell: ViewReusableIdentifier {}
