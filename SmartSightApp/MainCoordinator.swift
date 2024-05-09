//
//  MainCoordinator.swift
//  NewsApp
//
//  Created by Kazım Kağan İğci on 3.12.2023.
//

import UIKit

class MainCoordinator: Coordinator {
    let tabBarController = UITabBarController()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let homeNavigationController = UINavigationController()
        let homeCoordinator = HomeCoordinator(navigationController: homeNavigationController)
        homeCoordinator.start()
        homeCoordinator.navigationController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)

        let searchNavigationController = UINavigationController()
        let searchCoordinator = SearchCoordinator(navigationController: searchNavigationController)
        searchCoordinator.start()
        searchCoordinator.navigationController.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        
        let favoritesNavigationController = UINavigationController()
        let favoritesCoordinator = FavoritesCoordinator(navigationController: favoritesNavigationController)
        favoritesCoordinator.start()
        favoritesCoordinator.navigationController.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "star"), tag: 2)

        tabBarController.viewControllers = [homeCoordinator.navigationController, searchCoordinator.navigationController, favoritesCoordinator.navigationController]

        tabBarController.tabBar.backgroundColor = .white
        tabBarController.tabBar.tintColor = .gray
        tabBarController.tabBar.unselectedItemTintColor = .black
        tabBarController.navigationItem.hidesBackButton = true
        
        navigationController.pushViewController(self.tabBarController, animated: true)
    }
}
