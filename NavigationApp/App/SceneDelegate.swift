//
//  SceneDelegate.swift
//  NavigationApp
//
//  Created by Александр Нистратов on 16.10.2024.
//

import UIKit
import StorageService

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    let storageService = UserDefaultsService()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        storageService.onLoginStatusChahged = {
            print("@@@ onLoginStatusChahged")
            self.updateRootViewController()
        }
        
        updateRootViewController()
        
        window?.makeKeyAndVisible()
    }
}

private extension SceneDelegate {
    func updateRootViewController() {
        if storageService.getIsLoggedFlag() {
            showMainTabBarController()
        } else {
            showLoginViewController()
        }
    }
    
    func showLoginViewController() {
        let viewModel = LoginViewModel(userDefaultsService: storageService)
        let loginViewController = LogInViewController(viewModel: viewModel)
        
        window?.rootViewController = loginViewController
    }
    
    func showMainTabBarController() {
        let feedViewController = FeedViewController()
        let feedNavigationController = UINavigationController(rootViewController: feedViewController)
        feedNavigationController.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(systemName: "house.fill"), tag: 1)
                
        let profileViewModel = ProfileViewModel(userDefaultsService: storageService)
        let profileViewController = ProfileViewController(viewModel: profileViewModel)
        let profileNavigationController = UINavigationController(rootViewController: profileViewController)
        profileNavigationController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), tag: 2)
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [feedNavigationController, profileNavigationController]
        tabBarController.tabBar.tintColor = .blue
        tabBarController.tabBar.unselectedItemTintColor = .gray
        
        window?.rootViewController = tabBarController
    }
}
