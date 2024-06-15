//
//  PhotoCoordinator.swift
//  NewsApp
//
//  Created by Kazım Kağan İğci on 3.12.2023.
//

import Foundation
import UIKit

class PhotoCoordinator : Coordinator{
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = PhotoViewController(viewModel: PhotoViewModel(coordinator: self))
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showSelectPhotoScenerioPage(image: UIImage) {
        SelectPhotoScenerioCoordinator(
            navigationController: navigationController,
            image: image)
        .start()
    }
}
