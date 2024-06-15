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
        let photoNavigationController = UINavigationController()
        let photoCoordinator = PhotoCoordinator(navigationController: photoNavigationController)
        photoCoordinator.start()
        photoCoordinator.navigationController.tabBarItem = UITabBarItem(title: "Photo", image: UIImage(systemName: "photo"), tag: 0)
        
        let videoNavigationController = UINavigationController()
        let videoCoordinator = VideoCoordinator(navigationController: videoNavigationController)
        videoCoordinator.start()
        videoCoordinator.navigationController.tabBarItem = UITabBarItem(title: "Emotion", image: UIImage(systemName: "video"), tag: 1)
        
        let liveNavigationController = UINavigationController()
        let liveCoordinator = LiveCoordinator(navigationController: liveNavigationController)
        liveCoordinator.start()
        liveCoordinator.navigationController.tabBarItem = UITabBarItem(title: "Live", image: UIImage(systemName: "livephoto"), tag: 2)
        
        let aiNavigationController = UINavigationController()
        let aiCoordinator = AICoordinator(navigationController: aiNavigationController)
        aiCoordinator.start()
        aiCoordinator.navigationController.tabBarItem = UITabBarItem(title: "AI", image: UIImage(systemName: "gear"), tag: 3)
        
        let profileNavigationController = UINavigationController()
        let profileCoordinator = ProfileCoordinator(navigationController: profileNavigationController)
        profileCoordinator.start()
        profileCoordinator.navigationController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.crop.circle"), tag: 4)
        
        
        tabBarController.viewControllers = [photoCoordinator.navigationController,
                                            videoCoordinator.navigationController,
                                            liveCoordinator.navigationController,
                                            aiCoordinator.navigationController,
                                            profileCoordinator.navigationController]

        tabBarController.tabBar.backgroundColor = .white
        tabBarController.tabBar.tintColor = .gray
        tabBarController.tabBar.unselectedItemTintColor = .black
        tabBarController.navigationItem.hidesBackButton = true
        
        navigationController.pushViewController(self.tabBarController, animated: true)
    }
}
