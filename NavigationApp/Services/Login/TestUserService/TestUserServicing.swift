//
//  TestUserServicing.swift
//  NavigationApp
//
//  Created by Александр Нистратов on 08.02.2025.
//

import Foundation

protocol TestUserServicing {
    func testAuth(login: String, password: String) -> Result<User, AuthError>
}
