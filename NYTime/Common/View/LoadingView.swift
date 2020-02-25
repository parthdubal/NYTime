//
//  LoadingView.swift
//  NYTime
//
//  Created by Parth Dubal on 23/02/20.
//  Copyright © 2020 Parth Dubal. All rights reserved.
//

import UIKit

/// A type that support full page loader in a  view.
/// `FullPageLoaderProvider` provide basic setup for `LoadingView`and show/ hide capability.
///
/// `FullPageLoaderProvider` provides default implementation for  `UIViewController` instance.
protocol FullPageLoaderProvider {
    /// pageLoader instace to mange
    var pageLoader: LoadingView { get set }

    /// setup page loader view
    func setupPageLoader()
    /// show page loader view
    func showPageLoader()

    /// hide page loader view.
    func hidePageLoader()
}

// MARK: - Default implementation on UIViewController

extension FullPageLoaderProvider where Self: UIViewController {
    func setupPageLoader() {
        view.addSubview(pageLoader)
        NSLayoutConstraint.activate([
            pageLoader.widthAnchor.constraint(equalTo: view.widthAnchor),
            pageLoader.heightAnchor.constraint(equalTo: view.heightAnchor),
            pageLoader.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            pageLoader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }

    func showPageLoader() {
        setupPageLoader()
        pageLoader.isHidden = false
        view.isUserInteractionEnabled = false
    }

    func hidePageLoader() {
        pageLoader.removeFromSuperview()
        pageLoader.isHidden = true
        view.isUserInteractionEnabled = true
    }
}

/// A reusable  loader view.
/// `Loadingview` supports status label with indicator.
class LoadingView: UIView {
    private let loadingLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator: UIActivityIndicatorView
        if #available(iOS 13.0, *) {
            indicator = UIActivityIndicatorView(style: .large)
        } else {
            indicator = UIActivityIndicatorView(style: .whiteLarge)
            indicator.tintColor = .black
        }
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        return indicator
    }()

    private let containerView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    func setLoadingText(_ text: String) {
        loadingLabel.text = text
    }
}

// MARK: setup and initialise view section

private extension LoadingView {
    func commonInit() {
        setupView()
        setDefaultValues()
    }

    func setDefaultValues() {
        backgroundColor = UIColor.gray.withAlphaComponent(0.3)
        setLoadingText(localize(key: "loading"))
    }

    func setupView() {
        containerView.addArrangedSubview(activityIndicator)
        containerView.addArrangedSubview(loadingLabel)
        addSubview(containerView)
        setupContainerConstraints()
    }

    func setupContainerConstraints() {
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
