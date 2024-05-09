//
//  FavoritesViewController.swift
//  NewsApp
//
//  Created by Kazım Kağan İğci on 3.12.2023.
//
import Foundation
import UIKit

class FavoritesViewController: UIViewController {

    let viewModel: FavoritesViewModel

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    init(viewModel: FavoritesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorites"
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: NSNotification.Name(rawValue: "favorites"), object: nil)
    }
    @objc func handleNotification() {
        self.tableView.reloadData()
    }

}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MFUserDefaults.article?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier, for: indexPath) as? CustomCell else {
            return UITableViewCell()
        }
                if let articles = MFUserDefaults.article {
                let item = articles[indexPath.row]
                cell.configure(article: item)
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let articles = MFUserDefaults.article {
            let item = articles[indexPath.row]
            viewModel.presentDetailsPage(urlString: item.url)
            
        }
    }
}
