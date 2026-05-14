import UIKit

final class MainTabBarCoordinator: NSObject, TabBarControllerCoordinator {
    private(set) lazy var tabBarController = UITabBarController()
    var childCoordinators = [Coordinator]()

    func start() {
        tabBarController.viewControllers = [
            makeCategories(),
            makeSwiping(),
            makeProfile()
        ]
    }
}

private extension MainTabBarCoordinator {
    func makeCategories() -> UIViewController {
        let coordinator = CategoriesNavigationCoordinator()
        startChildCoordinator(coordinator)
        coordinator.rootViewController.tabBarItem = UITabBarItem(
            title: "Categories",
            image: UIImage(systemName: "list.dash.header.rectangle"),
            tag: 0
        )
        return coordinator.rootViewController
    }

    func makeSwiping() -> UIViewController {
        let coordinator = SwipingNavigationCoordinator()
        startChildCoordinator(coordinator)
        coordinator.rootViewController.tabBarItem = UITabBarItem(
            title: "Swiping",
            image: UIImage(systemName: "rectangle.portrait.and.arrow.forward"),
            tag: 1
        )
        return coordinator.rootViewController
    }

    func makeProfile() -> UIViewController {
        let coordinator = ProfileNavigationCoordinator()
        startChildCoordinator(coordinator)
        coordinator.rootViewController.tabBarItem = UITabBarItem(
            title: "About",
            image: UIImage(systemName: "info.circle"),
            tag: 2
        )
        return coordinator.rootViewController
    }
}

// MARK: - UIViewController alert helper
extension UIViewController {
    func showInfoAlert(title: String, message: String? = nil, handler: (() -> Void)? = nil) {
        guard presentedViewController == nil else { return }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in handler?() })
        present(alert, animated: true)
    }
}
