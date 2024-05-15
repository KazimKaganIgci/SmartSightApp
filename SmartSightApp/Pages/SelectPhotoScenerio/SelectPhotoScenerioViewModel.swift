//
//  SelectPhotoScenerioViewModel.swift
//  SmartSightApp
//
//  Created by Kazım Kağan İğci on 10.05.2024.
//

import Foundation
import UIKit

class SelectPhotoScenerioViewModel {
    let coordinator: SelectPhotoScenerioCoordinator

    init(coordinator: SelectPhotoScenerioCoordinator) {
        self.coordinator = coordinator
    }
    
    func presentConvertImagePage(image: UIImage, action: MLProcessType) {
        self.coordinator.showConvertImagePage(image: image, action: action)
    }
    
    func backButtonTapped() {
        self.coordinator.stop()
    }
}
