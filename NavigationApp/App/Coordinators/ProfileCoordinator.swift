import UIKit
import StorageService

final class ProfileCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []

    private let navigationController: UINavigationController
    private let storageService: UserDefaultsService

    init(navigationController: UINavigationController, storageService: UserDefaultsService) {
        self.navigationController = navigationController
        self.storageService = storageService
    }

    func start() {
        let user = User(login: "12345", name: "Вася", avatar: UIImage(named: "Шкет") ?? UIImage(systemName: "person.circle"))
        let viewModel = ProfileViewModel(userDefaultsService: storageService, user: user)
        let profileVC = ProfileViewController(viewModel: viewModel)
        
        profileVC.coordinator = self
        navigationController.setViewControllers([profileVC], animated: false)
    }

    func openPhotos() {
        let photosVC = PhotosViewController()
        navigationController.pushViewController(photosVC, animated: true)
    }
}
