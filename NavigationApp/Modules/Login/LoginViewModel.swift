//
//  LoginViewModel.swift
//  NavigationApp
//
//  Created by Александр Нистратов on 18.12.2024.
//

import StorageService

protocol LoginViewModeling {
    var delegate: LoginViewModelDelegate? { get set }
    func login(_ login: String, _ password: String)
}

final class LoginViewModel {
    private let userDefaultsService: UserDefaultsServicing
    private let userService: UserServicing
    private let testUserService: TestUserServicing
    weak var delegate: LoginViewModelDelegate?
    
    init(userDefaultsService: UserDefaultsServicing, userService: UserServicing) {
        self.userDefaultsService = userDefaultsService
        self.userService = userService
        self.testUserService = TestUserService()
    }
}

extension LoginViewModel: LoginViewModeling {
    func login(_ login: String, _ password: String) {
#if DEBUG
        let result = testUserService.testAuth(login: login, password: password)
#else
        let result = userService.auth(login: login, password: password)
       
#endif
        
        switch result {
        case .success(let success):
            print("✅ Успешный вход")
            userDefaultsService.setLoggedFlag(isLogIn: true)
        case .failure(let error):
            print("🚨 Ошибка в ViewModel: \(error.localizedDescription)") // Проверяем ошибку
            userDefaultsService.setLoggedFlag(isLogIn: false)
            delegate?.didReciveErorMessage(error.localizedDescription)
        }
    }
}
