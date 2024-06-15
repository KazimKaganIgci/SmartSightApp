//
//  VideoViewController.swift
//  SmartSightApp
//
//  Created by Kazım Kağan İğci on 3.12.2023.
//

import UIKit
import AVFoundation
import Vision

class VideoViewController: UIViewController {
    let viewModel: VideoViewModel
    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private let ageLabel = UILabel()
    private let genderLabel = UILabel()
    private let emotionLabel = UILabel()
    private let labelsContainerView = UIView()
    private var currentCameraPosition: AVCaptureDevice.Position = .back

    init(viewModel: VideoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
        setupLabels()
    }

    private func setupLabels() {
        labelsContainerView.translatesAutoresizingMaskIntoConstraints = false
        labelsContainerView.backgroundColor = .white
        view.addSubview(labelsContainerView)
        
        ageLabel.translatesAutoresizingMaskIntoConstraints = false
        genderLabel.translatesAutoresizingMaskIntoConstraints = false
        emotionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        labelsContainerView.addSubview(ageLabel)
        labelsContainerView.addSubview(genderLabel)
        labelsContainerView.addSubview(emotionLabel)
        labelsContainerView.backgroundColor = UIColor.lightGray

        NSLayoutConstraint.activate([
            labelsContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            labelsContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            labelsContainerView.topAnchor.constraint(equalTo: view.topAnchor),
            labelsContainerView.heightAnchor.constraint(equalToConstant: 120),
            
            ageLabel.topAnchor.constraint(equalTo: labelsContainerView.topAnchor, constant: 20),
            ageLabel.centerXAnchor.constraint(equalTo: labelsContainerView.centerXAnchor),
            
            genderLabel.topAnchor.constraint(equalTo: ageLabel.bottomAnchor, constant: 10),
            genderLabel.centerXAnchor.constraint(equalTo: labelsContainerView.centerXAnchor),
            
            emotionLabel.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: 10),
            emotionLabel.centerXAnchor.constraint(equalTo: labelsContainerView.centerXAnchor),
        ])
    }

    private func setupCamera() {
        captureSession = AVCaptureSession()
        configureCaptureSession(for: currentCameraPosition)
        captureSession.startRunning()
    }
    
    private func configureCaptureSession(for position: AVCaptureDevice.Position) {
        captureSession.beginConfiguration()
        
        if let inputs = captureSession.inputs as? [AVCaptureDeviceInput] {
            for input in inputs {
                captureSession.removeInput(input)
            }
        }
        
        guard let videoCaptureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position) else { return }
        
        let videoInput: AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            return
        }

        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        } else {
            return
        }

        captureSession.commitConfiguration()
        
        if previewLayer == nil {
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.frame = view.layer.bounds
            previewLayer.videoGravity = .resizeAspectFill
            view.layer.addSublayer(previewLayer)
        } else {
            previewLayer.session = captureSession
        }
    }
}

extension VideoViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

        let yoloModel = try! VNCoreMLModel(for: yolov8x().model)

        let yoloRequest = VNCoreMLRequest(model: yoloModel) { (finishedRequest, error) in
            guard let results = finishedRequest.results as? [VNRecognizedObjectObservation] else { return }
            
            let persons = results.filter { $0.labels.contains(where: { $0.identifier == "person" }) }
            
            if persons.isEmpty {
                DispatchQueue.main.async {
                    self.ageLabel.text = "No person detected"
                    self.genderLabel.text = ""
                    self.emotionLabel.text = ""
                }
                return
            }
            
            guard let person = persons.first else { return }
            
            let ageModel = try! VNCoreMLModel(for: AgeNet().model)
            let genderModel = try! VNCoreMLModel(for: GenderNet().model)
            let emotionModel = try! VNCoreMLModel(for: CNNEmotions().model)
            
            let ageRequest = VNCoreMLRequest(model: ageModel) { (finishedRequest, error) in
                guard let results = finishedRequest.results as? [VNClassificationObservation],
                      let firstResult = results.first else { return }
                DispatchQueue.main.async {
                    self.ageLabel.text = "Age: \(firstResult.identifier)"
                }
            }

            let genderRequest = VNCoreMLRequest(model: genderModel) { (finishedRequest, error) in
                guard let results = finishedRequest.results as? [VNClassificationObservation],
                      let firstResult = results.first else { return }
                DispatchQueue.main.async {
                    self.genderLabel.text = "Gender: \(firstResult.identifier)"
                }
            }

            let emotionRequest = VNCoreMLRequest(model: emotionModel) { (finishedRequest, error) in
                guard let results = finishedRequest.results as? [VNClassificationObservation],
                      let firstResult = results.first else { return }
                DispatchQueue.main.async {
                    self.emotionLabel.text = "Emotion: \(firstResult.identifier)"
                }
            }

            try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([ageRequest, genderRequest, emotionRequest])
        }

        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([yoloRequest])
    }
}
