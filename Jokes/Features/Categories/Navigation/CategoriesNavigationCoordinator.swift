import UIKit

final class CategoriesNavigationCoordinator: NSObject, NavigationControllerCoordinator {
    private(set) lazy var navigationController: UINavigationController = CustomNavigationController()
    var childCoordinators = [Coordinator]()

    func start() {
        navigationController.setViewControllers([CategoriesViewController()], animated: false)
    }
}
