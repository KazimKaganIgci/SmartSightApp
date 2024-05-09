//
//  SearchViewController.swift
//  NewsApp
//
//  Created by Kazım Kağan İğci on 3.12.2023.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {

    let viewModel: SearchViewModel
    private let disposeBag = DisposeBag()

    private let searchBar = UISearchBar()
    private let tableView = UITableView()

    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(CustomCell.self, forCellReuseIdentifier: "CustomCell")
        setupUI()
        bindViewModel()
    }

    private func setupUI() {
        view.backgroundColor = UIColor.white
        title = "Search"
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func bindViewModel() {
        searchBar.rx.text
            .orEmpty
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(to: viewModel.searchText)
            .disposed(by: disposeBag)

        viewModel.searchResults
            .bind(to: tableView.rx.items(cellIdentifier: "CustomCell")) { _, item, cell in
                if let customCell = cell as? CustomCell {
                    customCell.configure(article: item)
                }
            }
            .disposed(by: disposeBag)

        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                let selectedArticle = self.viewModel.searchResults.value[indexPath.row]
                self.viewModel.presentDetailsPage(urlString: selectedArticle.url)
            })
            .disposed(by: disposeBag)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
