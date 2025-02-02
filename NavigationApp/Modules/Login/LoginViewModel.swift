//
//  LoginViewModel.swift
//  NavigationApp
//
//  Created by Александр Нистратов on 18.12.2024.
//

import StorageService

protocol LoginViewModeling {
    func login(_ login: String) -> String?
}

final class LoginViewModel {
    private let userDefaultsService: UserDefaultsServicing
    private let userService: UserServicing
    
    init(userDefaultsService: UserDefaultsServicing, userService: UserServicing) {
        self.userDefaultsService = userDefaultsService
        self.userService = userService
    }
}

extension LoginViewModel: LoginViewModeling {
    func login(_ login: String) -> String? {
        let result = userService.auth(login: login)
        switch result {
        case .success(let success):
            print("success")
            userDefaultsService.setLoggedFlag(isLogIn: true)
            return nil
        case .failure(let failure):
            print("failure")
            userDefaultsService.setLoggedFlag(isLogIn: false)
            return failure.localizedDescription
        }
    }
}
