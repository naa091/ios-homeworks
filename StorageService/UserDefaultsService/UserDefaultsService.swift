//
//  UserDefaultsService.swift
//  NavigationApp
//
//  Created by Александр Нистратов on 18.12.2024.
//

import Foundation

public protocol UserDefaultsServicing {
    var onLoginStatusChahged: (() -> ())? { get }
    
    func setLoggedFlag(isLogIn: Bool)
    func getIsLoggedFlag() -> Bool
}

public final class UserDefaultsService {
    private enum Keys {
        static let isLoggedIn = "isLoggedIn"
    }
    
    private let defaults: UserDefaults
    public var onLoginStatusChahged: (() -> ())?
    
    public init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
}

extension UserDefaultsService: UserDefaultsServicing {
    public func setLoggedFlag(isLogIn: Bool) {
        defaults.set(isLogIn, forKey: Keys.isLoggedIn)
        onLoginStatusChahged?()
    }
    
    public func getIsLoggedFlag() -> Bool {
        defaults.bool(forKey: Keys.isLoggedIn)
    }
}
