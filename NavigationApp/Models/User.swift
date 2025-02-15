//
//  User.swift
//  StorageService
//
//  Created by Александр Нистратов on 02.02.2025.
//

import Foundation
import UIKit


struct User {
    let login: String
    let password: String
    let name: String
    let avatar: UIImage?
    
    init(
        login: String = "",
        password: String = "",
        name: String = "",
        avatar: UIImage? = nil
    ) {
        self.login = login
        self.password = password
        self.name = name
        self.avatar = avatar
    }
}
