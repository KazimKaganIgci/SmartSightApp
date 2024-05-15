//
//  ConvertImageCoordinator.swift
//  SmartSightApp
//
//  Created by Kazım Kağan İğci on 10.05.2024.
//

import Foundation
import UIKit

class ConvertImageCoordinator : Coordinator {
    var navigationController: UINavigationController
    var image: UIImage
    var action: MLProcessType
    init(navigationController: UINavigationController, image: UIImage, action: MLProcessType) {
        self.navigationController = navigationController
        self.image = image
        self.action = action
    }
    
    func start() {
        let vc = ConvertImageViewController(
            viewModel: ConvertImageViewModel(coordinator: self),
            image: image,
            action: action)
        
        navigationController.pushViewController(vc, animated: true)
    }
}
