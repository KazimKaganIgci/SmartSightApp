//
//  NewsRepository.swift
//  NewsApp
//
//  Created by Kazım Kağan İğci on 3.12.2023.
//

import Foundation

class NewsRepository {
    let newsNetworkService = NewsNetworkService()

    
    @discardableResult
    func getTopHeadlines(completion: @escaping (NewsResponse?) -> Void) -> Self {
        newsNetworkService.execute(completion: completion)
        return self
    }}
