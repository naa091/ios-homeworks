import Foundation

protocol UserDefaultsService {
    func getIsLoggedFlag() -> Bool
    func setIsLoggedFlag(_ value: Bool)
}

final class UserDefaultsServiceImpl: UserDefaultsService {
    private let key = "isLogged"
    func getIsLoggedFlag() -> Bool {
        UserDefaults.standard.bool(forKey: key)
    }
    func setIsLoggedFlag(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: key)
    }
}
