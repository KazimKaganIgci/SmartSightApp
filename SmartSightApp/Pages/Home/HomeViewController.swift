//
//  HomeViewController.swift
//  SmartSightApp
//
//  Created by Kazım Kağan İğci on 6.05.2024.
//

import UIKit
import AVFoundation
import MobileCoreServices
import Photos

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let mainOptions = ["Video Düzenle", "Fotoğraf Düzenle"]
    let subOptionsForVideo = ["Kamerayı Aç", "Galeriden Video Seç"]
    let subOptionsForPhoto = ["Kamerayı Aç", "Galeriden Fotoğraf Seç"]
    
    let viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: view.bounds, style: .grouped)
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return mainOptions.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return subOptionsForVideo.count
        } else {
            return subOptionsForPhoto.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return mainOptions[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .default, reuseIdentifier: "Cell")
        
        if indexPath.section == 0 {
            cell.textLabel?.text = subOptionsForVideo[indexPath.row]
        } else {
            cell.textLabel?.text = subOptionsForPhoto[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                checkCameraPermissionAndOpenCamera()
            } else if indexPath.row == 1 {
                checkPhotoLibraryPermissionAndOpenGallery(mediaType: kUTTypeMovie as String)
            }
        } else {
            if indexPath.row == 0 {
                checkCameraPermissionAndOpenCamera()
            } else if indexPath.row == 1 {
                checkPhotoLibraryPermissionAndOpenGallery(mediaType: kUTTypeImage as String)
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
        
    func checkCameraPermissionAndOpenCamera() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            openCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    self.openCamera()
                } else {
                    print("Kamera erişim izni reddedildi.")
                }
            }
        default:
            print("Kamera erişim izni reddedildi veya kısıtlandı.")
        }
    }
    
    func checkPhotoLibraryPermissionAndOpenGallery(mediaType: String) {
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
            openGallery(mediaType: mediaType)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                if status == .authorized {
                    self.openGallery(mediaType: mediaType)
                } else {
                    print("Fotoğraf galerisi erişim izni reddedildi.")
                }
            }
        default:
            print("Fotoğraf galerisi erişim izni reddedildi veya kısıtlandı.")
        }
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


}

