import UIKit

protocol AppCoordinating: ViewControllerCoordinator {}

final class AppCoordinator: AppCoordinating {
    private(set) lazy var rootViewController: UIViewController = makeTabBarFlow()
    var childCoordinators = [Coordinator]()

    func start() {
        setupGlobalAppearance()
    }
}

private extension AppCoordinator {
    func setupGlobalAppearance() {
        UITabBar.appearance().backgroundColor = .brown
        UITabBar.appearance().tintColor = .white
        UITabBarItem.appearance().setTitleTextAttributes(
            [.font: TextType.caption.uiFont],
            for: .normal
        )
        UINavigationBar.appearance().tintColor = .white
    }

    func makeTabBarFlow() -> UIViewController {
        let coordinator = MainTabBarCoordinator()
        startChildCoordinator(coordinator)
        return coordinator.rootViewController
    }
}
