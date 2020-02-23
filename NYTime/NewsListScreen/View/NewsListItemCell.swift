//
//  NewsListItemCell.swift
//  NYTime
//
//  Created by Parth Dubal on 22/02/20.
//  Copyright © 2020 Parth Dubal. All rights reserved.
//

import UIKit

class NewsListItemCell: UITableViewCell {
    var sepratorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

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
    func commonInit() {
        selectionStyle = .none

        textLabel?.lineBreakMode = .byTruncatingTail
        detailTextLabel?.lineBreakMode = .byTruncatingTail
        textLabel?.numberOfLines = 2
        detailTextLabel?.numberOfLines = 3

        setupSepratorView()
    }

    func setupSepratorView() {
        contentView.addSubview(sepratorView)
        NSLayoutConstraint.activate([
            sepratorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            sepratorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            sepratorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            sepratorView.heightAnchor.constraint(equalToConstant: 1.0),
        ])
    }

    func updateViewData() {
        textLabel?.text = item?.title
        detailTextLabel?.text = item?.description
        imageView?.image = item?.image
    }
}

extension NewsListItemCell: ViewReusableIdentifier {}
