//
//  SearchCoordinator.swift
//  NewsApp
//
//  Created by Kazım Kağan İğci on 3.12.2023.
//

import Foundation
import UIKit

class SearchCoordinator : Coordinator{
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = SearchViewController(viewModel: SearchViewModel(coordinator: self))
        navigationController.setViewControllers([vc], animated: false)
        navigationController.setNavigationBarHidden(false, animated: true)
    }
}
