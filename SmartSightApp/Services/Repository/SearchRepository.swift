//
//  SearchRepository.swift
//  NewsApp
//
//  Created by Kazım Kağan İğci on 4.12.2023.
//

import Foundation
import RxSwift
import Alamofire

class SearchRepository {

    let newsNetworkService = NewsNetworkService()

    func getTopHeadlines(query: String) -> Observable<[Article]> {
        return Observable.create { observer in
            self.newsNetworkService.searchExecute(value: query) { response in
                if let response = response {
                    observer.onNext(response.articles)
                    observer.onCompleted()
                } else {
                    print("error SearchRepository")
                }
            }

            return Disposables.create()
        }
    }
}
