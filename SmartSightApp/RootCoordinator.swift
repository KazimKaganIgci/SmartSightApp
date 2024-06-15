//
//  RootCoordinator.swift
//  NewsApp
//
//  Created by Kazım Kağan İğci on 3.12.2023.

import Foundation
import UIKit
import FirebaseAuth

class RootCoordinator: Coordinator {
    private let window: UIWindow?
    private var rootNavigationController: UINavigationController

    // Uygun init metodu
    init(window: UIWindow?) {
        self.window = window
        self.rootNavigationController = UINavigationController()
        
        self.window?.rootViewController = self.rootNavigationController
        self.window?.makeKeyAndVisible()
    }
    
    // Eğer rootNavigationController'ı dışarıdan alacaksanız bu init kullanılabilir
    init(rootNavigationController: UINavigationController) {
        self.window = nil
        self.rootNavigationController = rootNavigationController
    }
    
    func start() {
        if Auth.auth().currentUser != nil {
            rootNavigationController.presentedViewController?.dismiss(animated: false, completion: nil)
            MainCoordinator(navigationController: rootNavigationController).start()
        } else {
            
            rootNavigationController.presentedViewController?.dismiss(animated: false, completion: nil)
            LoginCoordinator(navigationController: rootNavigationController).start()
        }
    }
}
