//
//  ServiceFailureView.swift
//  NYTime
//
//  Created by Parth Dubal on 22/02/20.
//  Copyright © 2020 Parth Dubal. All rights reserved.
//

import UIKit

class ServiceFailureView: UIView {
    let serviceFailureLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let tryAgainButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityTraits = .button
        return button
    }()

    let containerView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        serviceFailureLabel.text = localize(key: "serviceError")
        tryAgainButton.setTitle(localize(key: "tryAgain"), for: .normal)

        containerView.addArrangedSubview(serviceFailureLabel)
        containerView.addArrangedSubview(tryAgainButton)
        addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }

    func addButtonHanler(target: Any?, selector: Selector) {
        tryAgainButton.addTarget(target, action: selector, for: .touchUpInside)
    }
}
