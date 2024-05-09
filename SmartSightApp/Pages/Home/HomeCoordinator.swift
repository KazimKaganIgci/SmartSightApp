//
//  HomeCoordinator.swift
//  NewsApp
//
//  Created by Kazım Kağan İğci on 3.12.2023.
//

import Foundation
import UIKit

class HomeCoordinator : Coordinator{
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = HomeViewController(viewModel: HomeViewModel(coordinator: self))
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showDetailsPage(urlString: String) {
        DetailsCoordinator(navigationController: navigationController, article: urlString).start()
    }
}
