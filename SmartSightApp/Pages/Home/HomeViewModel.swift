//
//  HomeViewModel.swift
//  NewsApp
//
//  Created by Kazım Kağan İğci on 3.12.2023.
//

import UIKit

class HomeViewModel: HomeViewModelProtocol {
    let coordinator: HomeCoordinator
    
    init(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
    }
    
    func presentSelectPhotoScenerioPage(image: UIImage) {
        self.coordinator.showSelectPhotoScenerioPage(image: image)
    }
}
