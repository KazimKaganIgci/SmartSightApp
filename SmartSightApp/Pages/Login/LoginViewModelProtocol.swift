//
//  LoginViewModelProtocol.swift
//  SmartSightApp
//
//  Created by Kazım Kağan İğci on 6.05.2024.
//

import Foundation

protocol LoginViewModelProtocol {
    func navigateToMainScreen()
    func loginButtonTapped(email: String, password: String, completion: @escaping (String?) -> Void)}
