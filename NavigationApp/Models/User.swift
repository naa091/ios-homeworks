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
    let name: String
    let avatar: UIImage?
    
    init(
        login: String = "",
        name: String = "",
        avatar: UIImage? = nil
    ) {
        self.login = login
        self.name = name
        self.avatar = avatar
    }
}
