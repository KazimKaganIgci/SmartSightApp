//
//  NetworkService.swift
//  NewsApp
//
//  Created by Kazım Kağan İğci on 3.12.2023.
//

import Foundation
import Alamofire

class NewsNetworkService {


    func execute(completion: @escaping (NewsResponse?) -> Void) {
        AF.request("https://newsapi.org/v2/top-headlines?country=us&apiKey=d698cf7f624f4cf08ee1a3bc73f4fb60")
            .validate()
            .responseDecodable(of: NewsResponse.self) { response in
                switch response.result {
                case .success(let model):
                    completion(model)
                case .failure(let error):
                    print("Error: \(error)")
                    completion(nil)
                }
            }
    }
    
    
    func searchExecute(value: String = "turkey", completion: @escaping (NewsResponse?) -> Void) {
        let apiKey = "d698cf7f624f4cf08ee1a3bc73f4fb60"
        let urlString = "https://newsapi.org/v2/everything?q=\(value)&sortBy=popularity&apiKey=\(apiKey)"
        
        AF.request(urlString)
            .validate()
            .responseDecodable(of: NewsResponse.self) { response in
                switch response.result {
                case .success(let model):
                    completion(model)
                case .failure(let error):
                    print("Error: \(error)")
                    completion(nil)
                }
            }
    }

    
}
