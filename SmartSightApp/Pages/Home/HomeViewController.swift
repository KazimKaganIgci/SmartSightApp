//
//  HomeViewController.swift
//  NewsApp
//
//  Created by Kazım Kağan İğci on 3.12.2023.
//

import UIKit
import RxSwift

class HomeViewController: UIViewController {
    let viewModel: HomeViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        view.backgroundColor = .white
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        tableView.register(CustomCell.self, forCellReuseIdentifier: "CustomCell")
        tableView.delegate = self
        tableView.dataSource = self

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.data
            .subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.data.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier, for: indexPath) as? CustomCell else {
            return UITableViewCell()
        }
        let item = viewModel.data.value[indexPath.row]
        cell.configure(article: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.presentDetailsPage(urlString: viewModel.data.value[indexPath.row].url)
    }
}

