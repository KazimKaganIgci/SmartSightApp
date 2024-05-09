//
//  Favorites.swift
//  NewsApp
//
//  Created by Kazım Kağan İğci on 3.12.2023.
//

import Foundation
import UIKit

class FavoritesCoordinator : Coordinator{
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = FavoritesViewController(viewModel: FavoritesViewModel(coordinator: self))
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showDetailsPage(urlString: String) {
        DetailsCoordinator(navigationController: navigationController, article: urlString).start()
    }
}
