//
//  UserService.swift
//  NavigationApp
//
//  Created by Александр Нистратов on 02.02.2025.
//

import Foundation

final class UserService {
    let user: User
    
    init(user: User) {
        self.user = user
    }
}

extension UserService: UserServicing {
    func auth(login: String, password: String) -> Result<User, AuthError> {
        guard user.login == login && user.password == password else { return .failure(.invalidLogin) }
        
        return .success(user)
    }
}
