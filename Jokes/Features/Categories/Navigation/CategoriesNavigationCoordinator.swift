import UIKit
import SwiftUI
import Combine

final class CategoriesNavigationCoordinator: NSObject, NavigationControllerCoordinator {
    private(set) lazy var navigationController: UINavigationController = CustomNavigationController()
    var childCoordinators = [Coordinator]()

    private var cancellables = Set<AnyCancellable>()

    func start() {
        let viewController = CategoriesViewController()
        viewController.eventPublisher
            .sink { [weak self] event in
                switch event {
                case .categorySelected(let category):
                    self?.showSwiping(for: category)
                }
            }
            .store(in: &cancellables)
        navigationController.setViewControllers([viewController], animated: false)
    }
}

private extension CategoriesNavigationCoordinator {
    func showSwiping(for category: String) {
        let viewController = UIHostingController(rootView: SwipingView(category: category))
        navigationController.pushViewController(viewController, animated: true)
    }
}
