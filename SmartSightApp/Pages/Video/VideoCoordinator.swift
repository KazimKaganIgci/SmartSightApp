//
//  VideoCoordinator.swift
//  SmartSightApp
//
//  Created by Kazım Kağan İğci on 3.04.2024.
//

import Foundation
import UIKit

class VideoCoordinator : Coordinator{
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = VideoViewController(viewModel: VideoViewModel(coordinator: self))
        navigationController.pushViewController(vc, animated: true)
    }
}
