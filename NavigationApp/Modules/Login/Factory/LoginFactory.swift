import UIKit

final class LoginFactory {
    static func build(userDefaultService: UserDefaultsService) -> UIViewController {
        let checker = CheckerService()
        let viewModel = LoginViewModel(checkerService: checker)
        let loginVC = LogInViewController(viewModel: viewModel)
        return loginVC
    }
}

