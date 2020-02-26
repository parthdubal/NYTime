//
//  ViewController.swift
//  NYTime
//
//  Created by Parth Dubal on 22/02/20.
//  Copyright © 2020 Parth Dubal. All rights reserved.
//

import SafariServices
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
        searchArticle()
    }

    /// Here we are binding updates from `NewsListViewModel` instances.
    /// Whenever any changes occures in `NewsListViewModel`, it notify to this updates.
    private func bindViewModelData() {
        viewModel.notifyUpdates = { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
        }

        viewModel.didUpdateService = { [weak self] status in
            guard let self = self else { return }
            switch status {
            case .initial:
                break
            case .refresh:
                self.showPageLoader()
            case .success:
                self.hidePageLoader()
                self.updateTableFooterView(isLoadingNextPage: false)
            case .loadmore:
                self.updateTableFooterView(isLoadingNextPage: true)
            case .error:
                self.setupFailureView()
                self.hidePageLoader()
            case .errorLoadMore:
                self.updateTableFooterView(isLoadingNextPage: false)
                self.hidePageLoader()
            }
            self.tableView.reloadData()
        }
    }
}

// MARK: - setup and initialise view section

private extension NewsListViewController {
    func setupView() {
        view.backgroundColor = .white
        title = localize(key: "title")
        setupTableView()
    }

    func setupTableView() {
        view.addSubview(tableView)
        // register `NewsListItemCell` to disaply on table
        tableView.register(NewsListItemCell.self,
                           forCellReuseIdentifier: NewsListItemCell.reusableIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        setupTableViewConstraints()
        tableView.reloadData()

        // Adding pull to refresh control.
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

    /// updateTableFooterView call whenver there request for load more page
    /// - Parameter isLoadingNextPage: Bool to provide current loading status for next page.
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

// MARK: - Action/event handler section

private extension NewsListViewController {
    @objc func refreshList() {
        searchArticle()
        tableView.refreshControl?.endRefreshing()
    }

    @objc func tryAgainHandler() {
        removeFailureView()
        tableView.isHidden = false
        searchArticle()
    }

    /// Send request for search news article
    func searchArticle() {
        viewModel.searchNewsArticle(query: "singapore")
    }
}

// MARK: - TableView datasources implementations.

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
        /// setting `NewsListItem` model to cell item
        cell.item = viewModel.newsListItems[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay _: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Validate load photo request of news item at indexPath.
        if viewModel.shouldLoadPhoto(tableView: tableView, indexPath: indexPath) {
            // sending load photo request for a indexPath
            viewModel.loadPhoto(indexPath: indexPath)
        }
        // Validate load more request for pagination.
        if viewModel.shouldLoadmore(tableView: tableView, indexPath: indexPath) {
            // sending next news page request.
            viewModel.loadNextPageArticle()
        }
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - TableView delegate implementations.

extension NewsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = viewModel.newsListItems[indexPath.row]

        guard let url = URL(string: item.webURL) else { return }
        openWebController(url: url)
    }

    /// Open news article on `SFSafariViewController` within app,
    /// - Parameter url: url for a news article.
    private func openWebController(url: URL) {
        let controller = SFSafariViewController(url: url)
        navigationController?.present(controller, animated: true, completion: nil)
    }
}

extension NewsListViewController: FullPageLoaderProvider {}
