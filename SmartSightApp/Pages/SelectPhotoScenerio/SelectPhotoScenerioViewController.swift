//
//  SelectPhotoScenerioViewController.swift
//  SmartSightApp
//
//  Created by Kazım Kağan İğci on 19.12.2023.
//

import UIKit

struct MLProcess {
    let id: String
    let name: String
    let description: String
    let type: MLProcessType
}

class SelectPhotoScenerioViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let image: UIImage
    let viewModel: SelectPhotoScenerioViewModel
    
    init(viewModel:SelectPhotoScenerioViewModel, image: UIImage) {
        self.viewModel = viewModel
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        self.navigationItem.title = "Select Photo Scenario"
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(handleBack))
        self.navigationItem.leftBarButtonItem = backButton
    }

    @objc func handleBack() {
        viewModel.backButtonTapped()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func setupTableView() {
        tableView.frame = view.bounds
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        view.addSubview(tableView)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.processes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let process = viewModel.processes[indexPath.row]
        cell.textLabel?.text = process.name
        cell.detailTextLabel?.text = process.description
        return cell
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedProcess = viewModel.processes[indexPath.row]
        handleProcess(withType: selectedProcess.type, image: image)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func handleProcess(withType type: MLProcessType, image: UIImage) {
        viewModel.presentConvertImagePage(image: image, action: type)
    }
}
