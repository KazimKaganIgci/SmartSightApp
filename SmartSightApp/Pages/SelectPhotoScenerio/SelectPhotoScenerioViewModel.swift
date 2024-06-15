//
//  SelectPhotoScenerioViewModel.swift
//  SmartSightApp
//
//  Created by Kazım Kağan İğci on 10.05.2024.
//

import Foundation
import UIKit

enum MLProcessType {
    case objectRecognition
    case faceRecognition
    case textRecognition
    case imageProcessing
    case emotionRecognition
    case documentScanning
}

class SelectPhotoScenerioViewModel {
    let coordinator: SelectPhotoScenerioCoordinator
    let processes: [MLProcess] = [
        MLProcess(id: "objectRecognition", name: "Object Recognition", description: "Recognize objects in the image", type: .objectRecognition),
        MLProcess(id: "faceRecognition", name: "Face Recognition", description: "Detect faces in the image", type: .faceRecognition),
        MLProcess(id: "textRecognition", name: "Text Recognition", description: "Recognize text in the image", type: .textRecognition),
        MLProcess(id: "imageProcessing", name: "Image Processing", description: "Process the image", type: .imageProcessing),
        MLProcess(id: "emotionRecognition", name: "Emotion Recognition", description: "Recognize emotions in the image", type: .emotionRecognition),
        MLProcess(id: "documentScanning", name: "Document Scanning", description: "Scan documents", type: .documentScanning),
    ]
    
    init(coordinator: SelectPhotoScenerioCoordinator) {
        self.coordinator = coordinator
    }
    
    func presentConvertImagePage(image: UIImage, action: MLProcessType) {
        self.coordinator.showConvertImagePage(image: image, action: action)
    }
    
    func backButtonTapped() {
        self.coordinator.stop()
    }
}
