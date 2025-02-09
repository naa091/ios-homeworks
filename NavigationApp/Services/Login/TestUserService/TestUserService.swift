//
//  TestUserService.swift
//  NavigationApp
//
//  Created by Александр Нистратов on 08.02.2025.
//

import Foundation

final class TestUserService {
    let user = User(login: "12345", password: "12345", name: "Nikolay", avatar: nil)
}

extension TestUserService: TestUserServicing {
    func testAuth(login: String, password: String) -> Result<User, AuthError> {
        if login == user.login && password == user.password {
            return .success(user)
        } else {
            return .failure(.invalidLogin)
        }
    }
}
