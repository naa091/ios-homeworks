import StorageService
import FirebaseAuth

protocol ProfileViewModeling {
    func logout()
    func currentUser() -> User
}

final class ProfileViewModel {
    private let userDefaultsService: UserDefaultsService
    private let user: User

    init(userDefaultsService: UserDefaultsService, user: User) {
        self.userDefaultsService = userDefaultsService
        self.user = user
    }
}

extension ProfileViewModel: ProfileViewModeling {
    func logout() {
        do {
            try Auth.auth().signOut()
            userDefaultsService.setIsLoggedFlag(false)
            NotificationCenter.default.post(name: .didLogout, object: nil)
        } catch {
            print("Ошибка выхода: \(error.localizedDescription)")
        }
    }

    func currentUser() -> User {
        user
    }
}

