//
//  LoginViewModel.swift
//  SmartSightApp
//
//  Created by Kazım Kağan İğci on 6.05.2024.
//

import Foundation
import FirebaseAuth

class LoginViewModel: LoginViewModelProtocol {
    let coordinator: LoginCoordinator

    init(coordinator: LoginCoordinator) {
        self.coordinator = coordinator
    }
    
    func navigateToMainScreen() {
        coordinator.showMainViewController()
    }
    
    func loginButtonTapped(email: String, password: String, completion: @escaping (String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            
            if let error = error {
                completion(error.localizedDescription)
            } else {
                strongSelf.navigateToMainScreen()
                completion(nil)
            }
        }
    }

    
    func registerButtonTapped() {
        coordinator.showRegisterViewController()
    }
}
