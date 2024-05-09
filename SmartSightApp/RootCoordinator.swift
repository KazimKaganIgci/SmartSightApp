//
//  RootCoordinator.swift
//  NewsApp
//
//  Created by Kazım Kağan İğci on 3.12.2023.

import Foundation
import UIKit

import UIKit

class RootCoordinator: Coordinator {
    private let window: UIWindow
    private var tabBarController: UITabBarController
    
    init() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.tabBarController = UITabBarController()
        self.window.rootViewController = self.tabBarController
        self.window.makeKeyAndVisible()
    }
    
    func start() {
        let homeCoordinator = HomeCoordinator(navigationController: UINavigationController())
        homeCoordinator.start()
        homeCoordinator.navigationController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        
        let searchCoordinator = SearchCoordinator(navigationController: UINavigationController())
        searchCoordinator.start()
        searchCoordinator.navigationController.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        
        let favoritesCoordinator = FavoritesCoordinator(navigationController: UINavigationController())
        favoritesCoordinator.start()
        favoritesCoordinator.navigationController.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "star"), tag: 2)
        
        tabBarController.viewControllers = [homeCoordinator.navigationController, searchCoordinator.navigationController, favoritesCoordinator.navigationController]
        
        tabBarController.tabBar.backgroundColor = .white
        tabBarController.tabBar.tintColor = .gray
        tabBarController.tabBar.unselectedItemTintColor = .black
    }
}
