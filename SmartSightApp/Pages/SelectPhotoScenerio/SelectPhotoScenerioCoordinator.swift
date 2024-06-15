//
//  SelectPhotoScenerioCoordinator.swift
//  SmartSightApp
//
//  Created by Kazım Kağan İğci on 19.12.2023.
//

import Foundation
import UIKit

class SelectPhotoScenerioCoordinator : Coordinator {
    var navigationController: UINavigationController
    var image: UIImage
    
    init(navigationController: UINavigationController, image: UIImage) {
        self.navigationController = navigationController
        self.image = image
    }
    
    func start() {
        let vc = SelectPhotoScenerioViewController(
            viewModel: SelectPhotoScenerioViewModel(coordinator: self),
            image:  image)
        vc.hidesBottomBarWhenPushed = true
        vc.navigationItem.hidesBackButton = true
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showConvertImagePage(image: UIImage, action: MLProcessType) {

        ConvertImageCoordinator(
            navigationController: navigationController,
            image: image,
            action: action)
        .start()
    }
    
    func stop() {
        navigationController.popViewController(animated: true)
    }
}
