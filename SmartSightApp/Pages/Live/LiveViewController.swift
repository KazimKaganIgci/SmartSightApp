//
//  LiveViewController.swift
//  SmartSightApp
//
//  Created by Kazım Kağan İğci on 3.12.2023.
//

import Foundation
import UIKit
import AVKit
import Vision

class LiveViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    let viewModel: LiveViewModel
    var topView = UIView()
    var objectNameLabel = UILabel()
    var accuracyLabel = UILabel()
    var lastRecognizedObject: String?

    init(viewModel: LiveViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        checkCameraPermission()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.white
        
        topView.backgroundColor = UIColor.lightGray
        topView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topView)
        
        NSLayoutConstraint.activate([
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topView.topAnchor.constraint(equalTo: view.topAnchor),
            topView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        objectNameLabel.translatesAutoresizingMaskIntoConstraints = false
        topView.addSubview(objectNameLabel)
        
        accuracyLabel.translatesAutoresizingMaskIntoConstraints = false
        topView.addSubview(accuracyLabel)
        
        NSLayoutConstraint.activate([
            objectNameLabel.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            objectNameLabel.topAnchor.constraint(equalTo: topView.topAnchor, constant: 10),
            accuracyLabel.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            accuracyLabel.topAnchor.constraint(equalTo: objectNameLabel.bottomAnchor, constant: 10)
        ])
    }
    
    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        self.setupCamera()
                    }
                }
            }
        case .denied, .restricted:
            showCameraAccessAlert()
        @unknown default:
            fatalError("Unknown authorization status")
        }
    }
    
    private func showCameraAccessAlert() {
        let alert = UIAlertController(title: "Camera Access Denied",
                                      message: "Please enable camera access in Settings.",
                                      preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        })
        present(alert, animated: true, completion: nil)
    }
    
    private func setupCamera() {
        let captureSession = AVCaptureSession()
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        captureSession.addInput(input)
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.insertSublayer(previewLayer, below: topView.layer)
        
        previewLayer.frame = CGRect(x: 0, y: 100, width: view.frame.width, height: view.frame.height - 100)
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(dataOutput)
        
        captureSession.startRunning()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        guard let inceptionModel = try? VNCoreMLModel(for: best4().model) else { return }
        let request = VNCoreMLRequest(model: inceptionModel) { (finishedReq, err) in
            guard let results = finishedReq.results as? [VNClassificationObservation],
                  let topResult = results.first else { return }
            
            let objectName = topResult.identifier
            let confidence = Int(topResult.confidence * 100)
            
            guard confidence >= 25 else { return }
            
            DispatchQueue.main.async {
                self.objectNameLabel.text = objectName
                self.accuracyLabel.text = "Accuracy: \(confidence)%"
            }

            if self.lastRecognizedObject == nil || self.lastRecognizedObject != objectName {
                self.lastRecognizedObject = objectName
                
                let speechSynthesizer = AVSpeechSynthesizer()
                let speechUtterance = AVSpeechUtterance(string: "\(objectName)")
                speechSynthesizer.speak(speechUtterance)
            }
        }

        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
}
