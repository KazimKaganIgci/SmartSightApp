//
//  PhotoViewModel.swift
//  NewsApp
//
//  Created by Kazım Kağan İğci on 3.12.2023.
//

import UIKit

class PhotoViewModel: PhotoViewModelProtocol {
    let coordinator: PhotoCoordinator
    
    init(coordinator: PhotoCoordinator) {
        self.coordinator = coordinator
    }
    
    func presentSelectPhotoScenerioPage(image: UIImage) {
        self.coordinator.showSelectPhotoScenerioPage(image: image)
    }
}
