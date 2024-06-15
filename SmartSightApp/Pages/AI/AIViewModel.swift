//
//  AIViewModel.swift
//  SmartSightApp
//
//  Created by Kazım Kağan İğci on 16.05.2024.
//

class AIViewModel: AIViewModelProtocol {
    let coordinator: AICoordinator

    init(coordinator: AICoordinator) {
        self.coordinator = coordinator
    }
}
