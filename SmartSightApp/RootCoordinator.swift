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
    private var rootNavigationController = UINavigationController()

    init() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window.makeKeyAndVisible()
        self.window.rootViewController = rootNavigationController

    }
    
    func start() {
        if Auth.auth().currentUser != nil {
            rootNavigationController.presentedViewController?.dismiss(animated: false)
             MainCoordinator(navigationController: rootNavigationController).start()
        } else {
            rootNavigationController.presentedViewController?.dismiss(animated: false)
            LoginCoordinator(navigationController: rootNavigationController).start()
        }
    }
}
