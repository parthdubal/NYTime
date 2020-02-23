//
//  ViewController.swift
//  NYTime
//
//  Created by Parth Dubal on 22/02/20.
//  Copyright © 2020 Parth Dubal. All rights reserved.
//

import UIKit

enum AccessibilityId: String {
    case NewListTableView
    case failureView
    case pageLoaderView
}

class NewsListViewController: UIViewController {

    lazy var pageLoader: LoadingView = {
        let view = LoadingView()
        view.accessibilityIdentifier = AccessibilityId.pageLoaderView.rawValue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var failureView: ServiceFailureView = {
        let view = ServiceFailureView()
        view.accessibilityIdentifier = AccessibilityId.failureView.rawValue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var tableView: UITableView = {
        let view = UITableView()
        view.accessibilityIdentifier = AccessibilityId.NewListTableView.rawValue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private(set) var viewModel: NewsListViewModel

    init(viewModel: NewsListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
        bindViewModelData()
        requestNews()
    }

    private func bindViewModelData() {
        viewModel.didUpdateService = { [weak self] status in
            guard let self = self else { return }
            switch status {
            case .initial:
                break
            case .loading:
                self.showPageLoader()
            case .successLoading:
                self.hidePageLoader()
                self.updateTableFooterView(isLoadingNextPage: false)
            case .loadingNextPage:
                self.updateTableFooterView(isLoadingNextPage: true)
            case .error:
                self.setupFailureView()
                self.hidePageLoader()
            case .errorNextPage:
                self.updateTableFooterView(isLoadingNextPage: false)
                self.hidePageLoader()
            }
            self.tableView.reloadData()
        }
    }
}

// MARK: setup and initialise view section

private extension NewsListViewController {
    func setupView() {
        view.backgroundColor = .white
        title = localize(key: "title")
        setupTableView()
    }

    func setupTableView() {
        view.addSubview(tableView)
        tableView.register(NewsListItemCell.self,
                           forCellReuseIdentifier: NewsListItemCell.reusableIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        setupTableViewConstraints()
        tableView.reloadData()

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self,
                                 action: #selector(refreshList),
                                 for: .valueChanged)

        tableView.refreshControl = refreshControl
        tableView.separatorStyle = .none
    }

    func setupTableViewConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    func setupFailureView() {
        tableView.isHidden = true
        if failureView.superview != nil {
            removeFailureView()
        }
        failureView.addButtonHanler(target: self,
                                    selector: #selector(tryAgainHandler))

        view.addSubview(failureView)

        NSLayoutConstraint.activate([
            failureView.widthAnchor.constraint(equalTo: view.widthAnchor),
            failureView.heightAnchor.constraint(equalTo: view.heightAnchor),
            failureView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            failureView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }

    func removeFailureView() {
        failureView.removeFromSuperview()
        tableView.isHidden = false
    }

    func updateTableFooterView(isLoadingNextPage: Bool) {
        if isLoadingNextPage {
            let view = LoadingView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60))
            view.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
            tableView.tableFooterView = view
        } else {
            tableView.tableFooterView = nil
        }
    }
}

// MARK: Action/event handler section

private extension NewsListViewController {
    @objc func refreshList() {
        requestNews()
        tableView.refreshControl?.endRefreshing()
    }

    @objc func tryAgainHandler() {
        removeFailureView()
        tableView.isHidden = false
        requestNews()
    }

    func requestNews() {
        viewModel.requestNews(query: "singapore")
    }
}

extension NewsListViewController: UITableViewDataSource {
    func tableView(_: UITableView,
                   numberOfRowsInSection _: Int) -> Int {
        return viewModel.newsListItems.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsListItemCell.reusableIdentifier,
                                                       for: indexPath) as? NewsListItemCell else {
            return UITableViewCell()
        }

        cell.item = viewModel.newsListItems[indexPath.row]

        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay _: UITableViewCell, forRowAt indexPath: IndexPath) {
        if viewModel.shouldLoadmore(tableView: tableView, indexPath: indexPath) {
            viewModel.loadNextNewsPage()
        }
    }
}

extension NewsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = viewModel.newsListItems[indexPath.row]

        guard let url = URL(string: item.webURL) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

extension NewsListViewController: FullPageLoaderProvider {}
