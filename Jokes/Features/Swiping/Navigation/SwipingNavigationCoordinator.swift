import UIKit
import SwiftUI

final class SwipingNavigationCoordinator: NSObject, NavigationControllerCoordinator {
    private(set) lazy var navigationController: UINavigationController = CustomNavigationController()
    var childCoordinators = [Coordinator]()

    func start() {
        navigationController.setViewControllers([makeSwipingView()], animated: false)
    }
}

private extension SwipingNavigationCoordinator {
    func makeSwipingView() -> UIViewController {
        UIHostingController(rootView: SwipingView())
    }
}
