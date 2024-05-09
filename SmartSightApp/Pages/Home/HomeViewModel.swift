//
//  HomeViewModel.swift
//  NewsApp
//
//  Created by Kazım Kağan İğci on 3.12.2023.
//

import RxSwift
import RxRelay

class HomeViewModel: HomeViewModelProtocol {
    var data = BehaviorRelay<[Article]>(value: [])
    let repository = NewsRepository()
    let coordinator: HomeCoordinator

    init(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
        super.init()
        self.getList()
    }

    private func getList() {
        repository.getTopHeadlines { [weak self] response in
            guard let self = self else { return }

            if let articles = response?.articles {
                self.data.accept(articles)
            }
        }
    }
    
    func presentDetailsPage(urlString: String) {
        self.coordinator.showDetailsPage(urlString: urlString)
    }
}
