import UIKit
import SwiftUI

final class ProfileNavigationCoordinator: NSObject, NavigationControllerCoordinator {
    private(set) lazy var navigationController: UINavigationController = CustomNavigationController()
    var childCoordinators = [Coordinator]()

    func start() {
        navigationController.setViewControllers([makeProfileView()], animated: false)
    }
}

private extension ProfileNavigationCoordinator {
    func makeProfileView() -> UIViewController {
        UIHostingController(rootView: ProfileView())
    }
}
