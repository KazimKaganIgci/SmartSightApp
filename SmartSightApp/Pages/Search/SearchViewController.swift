//
//  SearchViewController.swift
//  NewsApp
//
//  Created by Kazım Kağan İğci on 3.12.2023.
//

import UIKit

class SearchViewController: UIViewController {
    let viewModel: SearchViewModel

    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func setupUI() {
        view.backgroundColor = UIColor.white
        title = "Search"
    }
}
