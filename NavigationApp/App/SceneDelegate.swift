import UIKit
import FirebaseCore
import FirebaseAuth
import StorageService

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        self.window = window

        let storageService: UserDefaultsService = UserDefaultsServiceImpl() // или твой конкретный тип из StorageService

        appCoordinator = AppCoordinator(window: window, storageService: storageService)
        appCoordinator?.start()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Разлогинивание при завершении сцены
        do {
            try Auth.auth().signOut()
        } catch {
            print("Не удалось разлогиниться: \(error)")
        }
    }
}
