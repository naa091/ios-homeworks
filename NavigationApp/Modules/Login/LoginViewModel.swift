//
//  LoginViewModel.swift
//  NavigationApp
//
//  Created by Александр Нистратов on 18.12.2024.
//

import StorageService

protocol LoginViewModeling {
    func login()
}

final class LoginViewModel {
    private let userDefaultsService: UserDefaultsServicing
    
    init(userDefaultsService: UserDefaultsServicing) {
        self.userDefaultsService = userDefaultsService
    }
}

extension LoginViewModel: LoginViewModeling {
    func login() {
        userDefaultsService.setLoggedFlag(isLogIn: true)
    }
}
