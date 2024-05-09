//
//  RegisterCoordinator.swift
//  SmartSightApp
//
//  Created by Kazım Kağan İğci on 6.05.2024.
//

import Foundation
import UIKit

class RegisterCoordinator : Coordinator{
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = RegisterViewController(viewModel: RegisterViewModel(coordinator: self))
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showMainViewController() {
        MainCoordinator(navigationController: navigationController).start()
    }
}
