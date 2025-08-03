import UIKit
import StorageService

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        self.window = window

        let storageService = UserDefaultsService()
        appCoordinator = AppCoordinator(window: window, storageService: storageService)
        appCoordinator?.start()

        // 🔄 Новые рабочие URL с правильным SSL
        let configurations: [AppConfiguration] = [
            .dogImage(url: "https://dog.ceo/api/breeds/image/random"),
            .ageGuess(url: "https://api.agify.io/?name=lucy"),
            .genderGuess(url: "https://api.genderize.io/?name=michael")
        ]

        let randomConfig = configurations.randomElement()!
        NetworkService.request(for: randomConfig)
    }
}

