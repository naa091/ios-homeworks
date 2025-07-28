//
//  ProfileNewModel.swift
//  NavigationApp
//
//  Created by Александр Нистратов on 18.12.2024.
//
import StorageService

protocol ProfileViewModeling {
    func logout()
    func currentUser() -> User
}

final class ProfileViewModel {
    private let userDefaultsService: UserDefaultsServicing
    private let user: User
    
    init(userDefaultsService: UserDefaultsServicing, user: User) {
        self.userDefaultsService = userDefaultsService
        self.user = user
    }
}

extension ProfileViewModel: ProfileViewModeling {
    func logout() {
        userDefaultsService.setLoggedFlag(isLogIn: false)
    }
    
    func currentUser() -> User {
        user
    }
}
