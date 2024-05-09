//
//  SearchViewModel.swift
//  NewsApp
//
//  Created by Kazım Kağan İğci on 3.12.2023.
//

import Foundation
import RxSwift
import RxCocoa

class SearchViewModel {

    let searchText = BehaviorRelay<String>(value: "")
    let searchResults = BehaviorRelay<[Article]>(value: [])
    private let repository = SearchRepository()
    private let disposeBag = DisposeBag()
    let newsRepository = NewsRepository()
    let coordinator: SearchCoordinator

    init(coordinator: SearchCoordinator) {
        self.coordinator = coordinator
        bindSearch()
        getList()
    }

    private func bindSearch() {
        searchText
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { query -> Observable<[Article]> in
                return self.repository.getTopHeadlines(query: query)
                    .catch { error in
                        print("Error searching articles: \(error.localizedDescription)")
                        return Observable.just([])
                    }
            }
            .bind(to: searchResults)
            .disposed(by: disposeBag)
    }
    
    private func getList() {
        newsRepository.getTopHeadlines { [weak self] response in
            guard let self = self else { return }

            if let articles = response?.articles {
                self.searchResults.accept(articles)
            }
        }
    }
    
    func presentDetailsPage(urlString: String) {
        self.coordinator.showDetailsPage(urlString: urlString)
    }
}

