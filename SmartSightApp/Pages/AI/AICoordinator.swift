//
//  AICoordinator.swift
//  SmartSightApp
//
//  Created by Kazım Kağan İğci on 16.05.2024.
//

import Foundation
import UIKit

class AICoordinator : Coordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = AIViewController(viewModel: AIViewModel(coordinator: self))
        navigationController.pushViewController(vc, animated: true)
    }
}
