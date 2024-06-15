//
//  FavoritesViewModel.swift
//  NewsApp
//
//  Created by Kazım Kağan İğci on 3.12.2023.
//

class LiveViewModel: LiveViewModelProtocol {
    let coordinator: LiveCoordinator

    init(coordinator: LiveCoordinator) {
        self.coordinator = coordinator
    }
}
