//
//  RegisterViewModel.swift
//  SmartSightApp
//
//  Created by Kazım Kağan İğci on 6.05.2024.
//

import Foundation
import FirebaseAuth

class RegisterViewModel: RegisterViewModelProtocol {
    let coordinator: RegisterCoordinator

    init(coordinator: RegisterCoordinator) {
        self.coordinator = coordinator
    }
    
    private func navigateToMainScreen() {
        coordinator.showMainViewController()
    }
    
    func registerButtonTapped(email: String, password: String, completion: @escaping (String?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            
            if let error = error {
                completion(error.localizedDescription)
            } else {
                strongSelf.navigateToMainScreen()
                completion(nil)
            }
        }
    }
}
