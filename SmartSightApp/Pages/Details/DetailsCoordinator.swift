//
//  DetailsCoordinator.swift
//  NewsApp
//
//  Created by Kazım Kağan İğci on 19.12.2023.
//

import Foundation
import UIKit

class DetailsCoordinator : Coordinator{
    
    var navigationController: UINavigationController
    var urlString: String

    init(navigationController: UINavigationController, article: String) {
            self.navigationController = navigationController
            self.urlString = article
        }
        
    func start() {
            let vc = DetailsCoordinator(navigationController: navigationController, article: urlString)
            navigationController.present(DetailsViewController(article: urlString), animated: true)
        }
    }
