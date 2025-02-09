//
//  AuthError.swift
//  NavigationApp
//
//  Created by Александр Нистратов on 08.02.2025.
//

enum AuthError: Error {
    case invalidLogin
    
    var localizedDescription: String {
        switch self {
        case .invalidLogin:
            return "Invalid login"
        }
    }
}
