//
//  DetailsViewController.swift
//  NewsApp
//
//  Created by Kazım Kağan İğci on 19.12.2023.
//

import UIKit
import WebKit

class DetailsViewController: UIViewController, WKNavigationDelegate {
    let urlString: String
    
    lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        return webView
    }()
    
    init(article: String) {
        self.urlString = article
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadWebPage()
    }
    
    func setupUI() {
        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func loadWebPage() {
        if let urlString = self.urlString as? String, let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        } else {
            print("Geçersiz URL veya URL bulunamadı.")
        }
    }}

