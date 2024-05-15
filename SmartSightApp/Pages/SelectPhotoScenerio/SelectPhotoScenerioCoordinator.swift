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
    var secondNavigationController: UINavigationController?
    var image: UIImage
    
    init(navigationController: UINavigationController, image: UIImage) {
        self.navigationController = navigationController
        self.image = image
    }
    
    func start() {
        let secondNavigationController = UINavigationController()
        //secondNavigationController.setNavigationBarHidden(true, animated: false)
        let vc = SelectPhotoScenerioViewController(
            viewModel: SelectPhotoScenerioViewModel(coordinator: self),
            image:  image)
        //vc.hidesBottomBarWhenPushed = true
        secondNavigationController.viewControllers = [vc]
        secondNavigationController.modalPresentationStyle = .fullScreen
        navigationController.present(secondNavigationController, animated: true)
        self.secondNavigationController = secondNavigationController
    }
    
    func showConvertImagePage(image: UIImage, action: MLProcessType) {
        guard let secondNavigationController else { return }

        ConvertImageCoordinator(
            navigationController: secondNavigationController,
            image: image,
            action: action)
        .start()
    }
    
    func stop() {
        navigationController.dismiss(animated: true)
    }
}
