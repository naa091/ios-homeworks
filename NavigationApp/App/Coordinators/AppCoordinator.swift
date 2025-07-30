import UIKit
import StorageService

final class AppCoordinator: Coordinator {
    // MARK: - Properties
    
    var childCoordinators: [Coordinator] = []
    
    private let window: UIWindow
    private let storageService: UserDefaultsService
    private var tabBarController: UITabBarController?
    
    // Храним экземпляр LogInViewController, чтобы не создавать заново
    private var loginViewController: LogInViewController?
    
    // MARK: - Init
    
    init(window: UIWindow, storageService: UserDefaultsService) {
        self.window = window
        self.storageService = storageService
        
        self.storageService.onLoginStatusChahged = { [weak self] in
            print("🔄 onLoginStatusChahged вызван")
            self?.handleLoginStatusChange()
        }
    }
    
    // MARK: - Public
    
    func start() {
        if storageService.getIsLoggedFlag() {
            showMainInterface()
        } else {
            showLogin()
        }
    }
}

// MARK: - Private EXT

private extension AppCoordinator {
    func handleLoginStatusChange() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if self.storageService.getIsLoggedFlag() {
                print("👤 Пользователь залогинен, показываем главный интерфейс")
                self.showMainInterface()
            } else {
                print("🚪 Пользователь не залогинен, показываем экран логина")
                self.showLogin()
            }
        }
    }
    
    func showLogin() {
        childCoordinators.removeAll()
        
        if let loginVC = loginViewController {
            // Если контроллер уже создан, просто показываем его заново
            print("♻️ Показываем существующий LoginViewController")
            window.rootViewController = loginVC
            window.makeKeyAndVisible()
        } else {
            print("🆕 Создаём новый LoginViewController")
            let user = User(login: "123456", name: "Вася", avatar: UIImage(named: "Шкет"))
            let loginVC = LoginFactory.build(user: user, userDefaultService: storageService)
            loginViewController = loginVC
            window.rootViewController = loginVC
            window.makeKeyAndVisible()
        }
    }
    
    func showMainInterface() {
        let tabBarController = UITabBarController()
        self.tabBarController = tabBarController

        childCoordinators.removeAll()
        
        // MARK: Feed
        let feedNavController = UINavigationController()
        let feedCoordinator = FeedCoordinator(navigationController: feedNavController)
        addChild(feedCoordinator)
        feedCoordinator.start()
        feedNavController.tabBarItem = UITabBarItem(
            title: "Feed",
            image: UIImage(systemName: "house.fill"),
            tag: 0
        )

        // MARK: Profile
        let profileNavController = UINavigationController()
        let profileCoordinator = ProfileCoordinator(
            navigationController: profileNavController,
            storageService: storageService
        )
        addChild(profileCoordinator)
        profileCoordinator.start()
        profileNavController.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person.fill"),
            tag: 1
        )

        // MARK: Setup tabBar
        tabBarController.viewControllers = [feedNavController, profileNavController]
        tabBarController.tabBar.tintColor = .blue
        tabBarController.tabBar.unselectedItemTintColor = .gray

        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
}
