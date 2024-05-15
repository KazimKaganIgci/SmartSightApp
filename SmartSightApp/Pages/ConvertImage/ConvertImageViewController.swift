//
//  ConvertImageViewController.swift
//  SmartSightApp
//
//  Created by Kazım Kağan İğci on 10.05.2024.
//

import UIKit
import Vision
import VisionKit
import CoreML

class ConvertImageViewController: UIViewController {
    let image: UIImage
    let action: MLProcessType
    let viewModel: ConvertImageViewModel
    
    init(viewModel: ConvertImageViewModel, image: UIImage, action: MLProcessType) {
        self.viewModel = viewModel
        self.image = image
        self.action = action
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 24
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(label)
        view.backgroundColor = .white
        setupConstraints()
        imageView.image = image
        getActions()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSize(width: view.bounds.width, height: label.frame.origin.y + label.frame.height + 20)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40),
            imageView.heightAnchor.constraint(equalToConstant: 350),
            
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            label.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            label.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            label.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40)
        ])
    }
    
    private func getActions() {
        switch action {
        case .objectRecognition:
            performObjectRecognition()
        case .faceRecognition:
            performFaceRecognition()
        case .textRecognition:
            performTextRecognition()
        case .imageProcessing:
            performImageProcessing { image in
                guard let image else{ return }
                self.imageView.image = image
            }
            //        case .imageAnalysis:
            //            performImageAnalysis()
            //        case .emotionRecognition:
            //            performEmotionRecognition()
            //        case .documentScanning:
            //            performDocumentScanning()
            //        case .imageComparison:
            //            performImageComparison()
            //        case .imageEnhancement:
            //            performImageEnhancement()
            //        case .imageClassification:
            //            performImageClassification()
            //        case .imageSegmentation:
            //            performImageSegmentation()
            //        case .imageRegression:
            //            performImageRegression()
            //        case .imageGeneration:
            //            performImageGeneration()
            //        case .imageMarking:
            //            performImageMarking()
            //        case .imageMatching:
            //            performImageMatching()
            //        case .featureExtraction:
            //            performFeatureExtraction()
        default: break
        }
    }
    
    // Nesne tanıma işlemi
    func performObjectRecognition() {
        guard let model = try? VNCoreMLModel(for: MobileNetV2().model) else {
            print("Error: Unable to load Core ML model")
            return
        }
        
        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNClassificationObservation] else {
                print("Error: Unable to process Core ML request")
                return
            }
            
            let sortedResults = results.sorted(by: { $0.confidence > $1.confidence })
            var topResults = sortedResults.prefix(10)
            
            var textString = ""
            for result in topResults {
                print("Detected object: \(result.identifier) - Confidence: \(result.confidence)")
                textString += "Detected: \(result.identifier)\n \n"
            }
            self.label.text = textString
            
        }
        
        guard let cgImage = image.cgImage else {
            print("Error: Unable to create CGImage from UIImage")
            return
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        do {
            try handler.perform([request])
        } catch {
            print("Error performing object recognition: \(error)")
        }
    }

    
    func performFaceRecognition() {
        guard let cgImage = image.cgImage else { return }
        
        let request = VNDetectFaceRectanglesRequest { request, error in
            guard let results = request.results as? [VNFaceObservation] else { return }
            DispatchQueue.main.async {
                self.label.text = "Detected \(results.count) face(s)"
            }
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        do {
            try handler.perform([request])
        } catch {
            print("Error performing face recognition: \(error)")
        }
    }
    
    
    func performTextRecognition() {
        guard let cgImage = image.cgImage else { return }
        
        let request = VNRecognizeTextRequest { request, error in
            guard let results = request.results as? [VNRecognizedTextObservation] else { return }
            var textString = ""
            for observation in results {
                guard let topCandidate = observation.topCandidates(1).first else { continue }
                print("Detected text: \(topCandidate.string)")
                textString += "Detected text: \(topCandidate.string) \n"
            }
            
            self.label.text = textString
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        do {
            try handler.perform([request])
        } catch {
            print("Error performing text recognition: \(error)")
        }
    }
    
    func performImageProcessing(completion: @escaping (UIImage?) -> Void) {
        guard let ciImage = CIImage(image: image) else {
            completion(nil)
            return
        }
        
        let grayFilter = CIFilter(name: "CIPhotoEffectMono")
        grayFilter?.setValue(ciImage, forKey: kCIInputImageKey)
        guard let outputImage = grayFilter?.outputImage else {
            completion(nil)
            return
        }
        
        let context = CIContext(options: nil)
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            completion(nil)
            return
        }
        
        completion(UIImage(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation))
    }
    
}
