//
//  PhotoViewController.swift
//  SmartSightApp
//
//  Created by Kazım Kağan İğci on 6.05.2024.
//

import UIKit
import AVFoundation
import MobileCoreServices
import Photos

class PhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let viewModel: PhotoViewModel
    
    init(viewModel: PhotoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Photo"
        view.backgroundColor = .white
        
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        
        let cameraImageView = UIImageView(image: UIImage(named: "camera"))
        cameraImageView.contentMode = .scaleAspectFit
        cameraImageView.isUserInteractionEnabled = true
        cameraImageView.layer.cornerRadius = 12
        cameraImageView.clipsToBounds = true
        cameraImageView.contentMode = .scaleAspectFill

        cameraImageView.translatesAutoresizingMaskIntoConstraints = false
        let cameraTapGesture = UITapGestureRecognizer(target: self, action: #selector(openCameraTapped))
        cameraImageView.addGestureRecognizer(cameraTapGesture)
        
        let galleryImageView = UIImageView(image: UIImage(named: "photos"))
        galleryImageView.contentMode = .scaleAspectFit
        galleryImageView.isUserInteractionEnabled = true
        galleryImageView.layer.cornerRadius = 12
        galleryImageView.clipsToBounds = true
        galleryImageView.contentMode = .scaleAspectFill
        galleryImageView.translatesAutoresizingMaskIntoConstraints = false
        let galleryTapGesture = UITapGestureRecognizer(target: self, action: #selector(openGalleryTapped))
        galleryImageView.addGestureRecognizer(galleryTapGesture)
        
        let stackView = UIStackView(arrangedSubviews: [cameraImageView, galleryImageView])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cameraImageView.heightAnchor.constraint(equalToConstant: 300),
            galleryImageView.heightAnchor.constraint(equalToConstant: 300),
            cameraImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cameraImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            galleryImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            galleryImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func openCameraTapped() {
        checkCameraPermissionAndOpenCamera()
    }
    
    @objc private func openGalleryTapped() {
        checkPhotoLibraryPermissionAndOpenGallery(mediaType: kUTTypeImage as String)
    }
    
    func checkCameraPermissionAndOpenCamera() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            openCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        self.openCamera()
                    } else {
                        self.showPermissionDeniedAlert(for: "Kamera")
                    }
                }
            }
        default:
            showPermissionDeniedAlert(for: "Kamera")
        }
    }
    
    func checkPhotoLibraryPermissionAndOpenGallery(mediaType: String) {
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
            openGallery(mediaType: mediaType)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    if status == .authorized {
                        self.openGallery(mediaType: mediaType)
                    } else {
                        self.showPermissionDeniedAlert(for: "Fotoğraf Galerisi")
                    }
                }
            }
        default:
            showPermissionDeniedAlert(for: "Fotoğraf Galerisi")
        }
    }
    
    func showPermissionDeniedAlert(for feature: String) {
        let alert = UIAlertController(title: "\(feature) Erişim İzni Gerekli",
                                      message: "\(feature) erişimi için ayarlardan izin vermeniz gerekmektedir.", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Ayarlara Git", style: .default, handler: { _ in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    func openCamera() {
        DispatchQueue.main.async {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            } else {
                print("Kamera kullanılamıyor.")
            }
        }
    }

    func openGallery(mediaType: String) {
        DispatchQueue.main.async {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary
                imagePicker.mediaTypes = [mediaType]
                self.present(imagePicker, animated: true, completion: nil)
            } else {
                print("Fotoğraf galerisi kullanılamıyor.")
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[.originalImage] as? UIImage {
            handleSelectedImage(image)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func handleSelectedImage(_ image: UIImage) {
        viewModel.presentSelectPhotoScenerioPage(image: image)
        print("Seçilen fotoğraf: \(image)")
    }
}
