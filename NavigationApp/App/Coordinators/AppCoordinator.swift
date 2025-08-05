import UIKit
import FirebaseAuth

extension Notification.Name {
    static let didLogin = Notification.Name("didLogin")
    static let didLogout = Notification.Name("didLogout")
}

final class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []

    private let window: UIWindow
    private let storageService: UserDefaultsService
    private var tabBarController: UITabBarController?
    private var loginViewController: UIViewController?

    init(window: UIWindow, storageService: UserDefaultsService) {
        self.window = window
        self.storageService = storageService

        NotificationCenter.default.addObserver(self, selector: #selector(handleLoginStatusChange), name: .didLogin, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleLoginStatusChange), name: .didLogout, object: nil)

        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.handleLoginStatusChange()
        }
    }

    func start() {
        if storageService.getIsLoggedFlag(), Auth.auth().currentUser != nil {
            showMainInterface()
        } else {
            showLogin()
        }
    }

    @objc private func handleLoginStatusChange() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if Auth.auth().currentUser != nil {
                self.storageService.setIsLoggedFlag(true)
                self.showMainInterface()
            } else {
                self.storageService.setIsLoggedFlag(false)
                self.showLogin()
            }
        }
    }

    private func showLogin() {
        childCoordinators.removeAll()
        if let vc = loginViewController {
            window.rootViewController = vc
            window.makeKeyAndVisible()
        } else {
            let loginVC = LoginFactory.build(userDefaultService: storageService)
            loginViewController = loginVC
            window.rootViewController = loginVC
            window.makeKeyAndVisible()
        }
    }

    private func showMainInterface() {
        let tabBarController = UITabBarController()
        self.tabBarController = tabBarController
        childCoordinators.removeAll()

        let feedNavController = UINavigationController()
        let feedCoordinator = FeedCoordinator(navigationController: feedNavController)
        addChild(feedCoordinator)
        feedCoordinator.start()
        feedNavController.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(systemName: "house.fill"), tag: 0)

        let profileNavController = UINavigationController()
        let profileCoordinator = ProfileCoordinator(navigationController: profileNavController, storageService: storageService)
        addChild(profileCoordinator)
        profileCoordinator.start()
        profileNavController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), tag: 1)

        tabBarController.viewControllers = [feedNavController, profileNavController]
        tabBarController.tabBar.tintColor = .blue
        tabBarController.tabBar.unselectedItemTintColor = .gray

        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
}

