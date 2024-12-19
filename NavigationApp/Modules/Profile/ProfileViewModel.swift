//
//  ProfileNewModel.swift
//  NavigationApp
//
//  Created by Александр Нистратов on 18.12.2024.
//
import StorageService

protocol ProfileViewModeling {
    func logout()
}

final class ProfileViewModel {
    private let userDefaultsService: UserDefaultsServicing
    
    init(userDefaultsService: UserDefaultsServicing) {
        self.userDefaultsService = userDefaultsService
    }
}

extension ProfileViewModel: ProfileViewModeling {
    func logout() {
        userDefaultsService.setLoggedFlag(isLogIn: false)
    }
}
