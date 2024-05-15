//
//  FavoritesViewModel.swift
//  NewsApp
//
//  Created by Kazım Kağan İğci on 3.12.2023.
//

import Foundation

class FavoritesViewModel: FavoritesViewModelProtocol {
    let coordinator: FavoritesCoordinator

    init(coordinator: FavoritesCoordinator) {
        self.coordinator = coordinator
    }
    
//    func presentDetailsPage(urlString: String) {
//        self.coordinator.showDetailsPage(urlString: urlString)
//    }
}
