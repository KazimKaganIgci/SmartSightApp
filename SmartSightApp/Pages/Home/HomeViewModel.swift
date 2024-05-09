//
//  HomeViewModel.swift
//  NewsApp
//
//  Created by Kazım Kağan İğci on 3.12.2023.
//

import RxSwift
import RxRelay

class HomeViewModel: HomeViewModelProtocol {
    let coordinator: HomeCoordinator

    init(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
    }

    
    func presentDetailsPage(urlString: String) {
        self.coordinator.showDetailsPage(urlString: urlString)
    }
}
