//
//  ViewController.swift
//  NYTime
//
//  Created by Parth Dubal on 22/02/20.
//  Copyright © 2020 Parth Dubal. All rights reserved.
//

import UIKit

class NewsListViewController: UIViewController {
    lazy var pageLoader: LoadingView = {
        let view = LoadingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var failureView: ServiceFailureView = {
        let view = ServiceFailureView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var tableFooterView: LoadingView? {
        return tableView.tableFooterView as? LoadingView
    }

    var list = [NewsListItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        list = mockData()
        setupView()
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
        setupTableViewConstraints()
        tableView.reloadData()

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self,
                                 action: #selector(refreshList),
                                 for: .valueChanged)

        tableView.refreshControl = refreshControl
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
    }

    func setupTableFooterView() {
        if tableFooterView == nil {
            let view = LoadingView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60))
            view.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
            tableView.tableFooterView = view
        }
    }
}

// MARK: Action/event handler section

private extension NewsListViewController {
    @objc func refreshList() {
        showPageLoader()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.hidePageLoader()
            self.tableView.refreshControl?.endRefreshing()
        }
    }

    @objc func tryAgainHandler() {
        removeFailureView()
        tableView.isHidden = false
    }
}

extension NewsListViewController: UITableViewDataSource {
    func tableView(_: UITableView,
                   numberOfRowsInSection _: Int) -> Int {
        return list.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsListItemCell.reusableIdentifier, for: indexPath) as? NewsListItemCell else {
            return UITableViewCell()
        }

        cell.item = list[indexPath.row]

        if indexPath.row == list.count - 1 {
            setupTableFooterView()
        }
        return cell
    }
}

extension NewsListViewController {
    func mockData() -> [NewsListItem] {
        let item1 = NewsListItem(title: "Abc", imageUrl: "", description: "fidsffdfdfdne", publishDate: "date...")
        let item2 = NewsListItem(title: "Abcdsf", imageUrl: "", description: "finidjmvkcxe", publishDate: "date...")
        let item3 = NewsListItem(title: "Abcwer", imageUrl: "", description: "fifdfdfdne", publishDate: "date...")
        let item4 = NewsListItem(title: "Abcxcv", imageUrl: "", description: "fdfdfdfine", publishDate: "date...")
        let item5 = NewsListItem(title: "Abcwte", imageUrl: "", description: "fintryertre", publishDate: "date...")
        let item6 = NewsListItem(title: "Abctyfdg", imageUrl: "", description: "fiukjhgfhnbvvbcxne", publishDate: "date...")

        let list = [item1, item2, item3, item4, item5, item6]
        return list.shuffled() + list.shuffled()
    }
}

extension NewsListViewController: FullPageLoaderProvider {}
