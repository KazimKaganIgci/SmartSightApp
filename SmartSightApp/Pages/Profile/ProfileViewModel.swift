//
//  ProfileViewModel.swift
//  SmartSightApp
//
//  Created by Kazım Kağan İğci on 16.05.2024.
//

enum ProfileOption: Int, CaseIterable {
    case recommendations
    case favorites
    case logout
    
    var title: String {
        switch self {
        case .recommendations:
            return "Recommendations"
        case .favorites:
            return "Favorites"
        case .logout:
            return "Logout"
        }
    }
}

class ProfileViewModel: ProfileViewModelProtocol {
    let coordinator: ProfileCoordinator
    
    init(coordinator: ProfileCoordinator) {
        self.coordinator = coordinator
    }
    
    func present(option: ProfileOption) {
        switch option {
        case .recommendations:
            presentRecommendations()
        case .favorites:
            presentFavorites()
        case .logout:
            logout()
        }
    }
    
    private func presentRecommendations() {
        print("Presenting Recommendations")
    }
    
    private func presentFavorites() {
        print("Presenting Favorites")
    }
    
    private func logout() {
        coordinator.logout()
    }
}
