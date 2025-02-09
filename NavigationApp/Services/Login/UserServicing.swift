//
//  UserServicing.swift
//  NavigationApp
//
//  Created by Александр Нистратов on 02.02.2025.
//

protocol UserServicing {
    func auth(login: String) -> Result<User, AuthError>
}
