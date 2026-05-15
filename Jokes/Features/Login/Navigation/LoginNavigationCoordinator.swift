import Combine
import SwiftUI
import UIKit

enum LoginCoordinatorEvent {
    case loggedIn(Coordinator)
}

final class LoginNavigationCoordinator: NSObject, NavigationControllerCoordinator, EventEmitting {
    typealias Event = LoginCoordinatorEvent

    private(set) lazy var navigationController: UINavigationController = CustomNavigationController()
    var childCoordinators = [Coordinator]()
    private let eventSubject = PassthroughSubject<LoginCoordinatorEvent, Never>()
    private var cancellables = Set<AnyCancellable>()

    var eventPublisher: AnyPublisher<LoginCoordinatorEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }

    func start() {
        navigationController.setViewControllers([makeLoginView()], animated: false)
    }
}

// MARK: - Private
private extension LoginNavigationCoordinator {
    func makeLoginView() -> UIViewController {
        let store = LoginStore()
        store.eventPublisher
            .sink { [weak self] event in
                switch event {
                case .loggedIn:
                    guard let self else {
                        return
                    }
                    eventSubject.send(.loggedIn(self))
                }
            }
            .store(in: &cancellables)
        return UIHostingController(rootView: LoginView(store: store))
    }
}
