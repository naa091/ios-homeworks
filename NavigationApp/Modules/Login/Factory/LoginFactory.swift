//
//  LoginFactory.swift
//  NavigationApp
//
//  Created by Александр Нистратов on 15.02.2025.
//

import StorageService

final class LoginFactory {
    static func build(user: User, userDefaultService: UserDefaultsServicing) -> LogInViewController {
        let userService = UserService(user: user)
        let viewModel = LoginViewModel(userDefaultsService: userDefaultService, userService: userService)
        let loginVC = LogInViewController(viewModel: viewModel)
        viewModel.delegate = loginVC
        
        return loginVC
    }
}
