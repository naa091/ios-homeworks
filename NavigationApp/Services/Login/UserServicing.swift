//
//  UserServicing.swift
//  NavigationApp
//
//  Created by Александр Нистратов on 02.02.2025.
//

import Foundation
enum AuthError: Error {
    case invalidLogin
    
    var localizedDescription: String {
        switch self {
        case .invalidLogin:
            return "Invalid login"
        }
    }
}

protocol UserServicing {
    func auth(login: String) -> Result<User, AuthError>
}
