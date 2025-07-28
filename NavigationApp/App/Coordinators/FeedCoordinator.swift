import UIKit

final class FeedCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []

    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let feedVC = FeedViewController()
        feedVC.coordinator = self
        navigationController.setViewControllers([feedVC], animated: false)
    }

    func openPost(withColor color: UIColor) {
        let postVC = PostViewController(customBackgroundColor: color)
        navigationController.pushViewController(postVC, animated: true)
    }
}
