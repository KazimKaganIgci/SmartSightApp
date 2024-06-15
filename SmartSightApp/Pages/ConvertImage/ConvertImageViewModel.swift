//
//  ConvertImageViewModel.swift
//  SmartSightApp
//
//  Created by Kazım Kağan İğci on 10.05.2024.
//

import Foundation

class ConvertImageViewModel {
    let coordinator: ConvertImageCoordinator
    let action: MLProcessType

    init(coordinator: ConvertImageCoordinator, action: MLProcessType) {
        self.coordinator = coordinator
        self.action = action
    }
}
