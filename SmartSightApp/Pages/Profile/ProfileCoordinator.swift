//
//  ProfileCoordinator.swift
//  SmartSightApp
//
//  Created by Kazım Kağan İğci on 16.05.2024.
//

import Foundation
import UIKit
import FirebaseAuth

class ProfileCoordinator : Coordinator{
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = ProfileViewController(viewModel: ProfileViewModel(coordinator: self))
        navigationController.pushViewController(vc, animated: true)
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            
            let rootCoordinator = RootCoordinator(rootNavigationController: navigationController)
            rootCoordinator.start()
            
            print("User signed out successfully")
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
