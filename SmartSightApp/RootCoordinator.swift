//
//  RootCoordinator.swift
//  NewsApp
//
//  Created by Kazım Kağan İğci on 3.12.2023.

import Foundation
import UIKit
import FirebaseAuth

class RootCoordinator: Coordinator {
    private let window: UIWindow
    private let navigationController = UINavigationController()

    init() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window.makeKeyAndVisible()
    }
    
    func start() {
        if Auth.auth().currentUser != nil {
            let mainCoordinator =  MainCoordinator(navigationController: navigationController)
            window.rootViewController = mainCoordinator.navigationController
            mainCoordinator.start()
        } else {
            let loginCoordinator = LoginCoordinator(navigationController: navigationController)
            window.rootViewController = loginCoordinator.navigationController
            loginCoordinator.start()
        }
    }
}
