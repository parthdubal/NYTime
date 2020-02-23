//
//  LoadMoreFooterView.swift
//  NYTime
//
//  Created by Parth Dubal on 23/02/20.
//  Copyright © 2020 Parth Dubal. All rights reserved.
//

import UIKit

class LoadMoreFooterView: UITableViewHeaderFooterView {
    var loadignView: LoadingView = {
        let view = LoadingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        loadignView.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        contentView.addSubview(loadignView)

        NSLayoutConstraint.activate([
            loadignView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            loadignView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            loadignView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            loadignView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
    }
}

extension LoadMoreFooterView: ViewReusableIdentifier {}
