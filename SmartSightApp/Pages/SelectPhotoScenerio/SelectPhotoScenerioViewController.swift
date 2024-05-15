//
//  SelectPhotoScenerioViewController.swift
//  SmartSightApp
//
//  Created by Kazım Kağan İğci on 19.12.2023.
//

import UIKit

enum MLProcessType {
    case objectRecognition
    case faceRecognition
    case textRecognition
    case imageProcessing
    case imageAnalysis
    case emotionRecognition
    case documentScanning
    case imageComparison
    case imageEnhancement
    case imageClassification
    case imageSegmentation
    case imageRegression
    case imageGeneration
    case imageMarking
    case imageMatching
    case featureExtraction
}


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
    let processes: [MLProcess] = [
        MLProcess(id: "objectRecognition", name: "Object Recognition", description: "Recognize objects in the image", type: .objectRecognition),
        MLProcess(id: "faceRecognition", name: "Face Recognition", description: "Detect faces in the image", type: .faceRecognition),
        MLProcess(id: "textRecognition", name: "Text Recognition", description: "Recognize text in the image", type: .textRecognition),
        MLProcess(id: "imageProcessing", name: "Image Processing", description: "Process the image", type: .imageProcessing),
        MLProcess(id: "imageAnalysis", name: "Image Analysis", description: "Analyze the image", type: .imageAnalysis),
        MLProcess(id: "emotionRecognition", name: "Emotion Recognition", description: "Recognize emotions in the image", type: .emotionRecognition),
        MLProcess(id: "documentScanning", name: "Document Scanning", description: "Scan documents", type: .documentScanning),
        MLProcess(id: "imageComparison", name: "Image Comparison", description: "Compare images", type: .imageComparison),
        MLProcess(id: "imageEnhancement", name: "Image Enhancement", description: "Enhance the image", type: .imageEnhancement),
        MLProcess(id: "imageClassification", name: "Image Classification", description: "Classify the image", type: .imageClassification),
        MLProcess(id: "imageSegmentation", name: "Image Segmentation", description: "Segment the image", type: .imageSegmentation),
        MLProcess(id: "imageRegression", name: "Image Regression", description: "Regression on the image", type: .imageRegression),
        MLProcess(id: "imageGeneration", name: "Image Generation", description: "Generate image", type: .imageGeneration),
        MLProcess(id: "imageMarking", name: "Image Marking", description: "Mark the image", type: .imageMarking),
        MLProcess(id: "imageMatching", name: "Image Matching", description: "Match images", type: .imageMatching),
        MLProcess(id: "featureExtraction", name: "Feature Extraction", description: "Extract features from the image", type: .featureExtraction)
    ]

    
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
        return processes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let process = processes[indexPath.row]
        cell.textLabel?.text = process.name
        cell.detailTextLabel?.text = process.description
        return cell
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedProcess = processes[indexPath.row]
        handleProcess(withType: selectedProcess.type, image: image)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func handleProcess(withType type: MLProcessType, image: UIImage) {
        viewModel.presentConvertImagePage(image: image, action: type)
    }
}
