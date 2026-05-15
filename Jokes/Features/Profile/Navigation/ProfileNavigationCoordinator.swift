import Combine
import Dependencies
import SwiftUI
import UIKit

enum ProfileCoordinatorEvent {
    case loggedOut(Coordinator)
}

final class ProfileNavigationCoordinator: NSObject, NavigationControllerCoordinator, EventEmitting {
    typealias Event = ProfileCoordinatorEvent

    private(set) lazy var navigationController: UINavigationController = CustomNavigationController()
    var childCoordinators = [Coordinator]()
    private var cancellables = Set<AnyCancellable>()
    private let eventSubject = PassthroughSubject<ProfileCoordinatorEvent, Never>()

    var eventPublisher: AnyPublisher<ProfileCoordinatorEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }

    @Dependency(\.authManager) private var authManager
    private lazy var store: ProfileStore = makeStore()

    func start() {
        navigationController.setViewControllers([makeProfileView()], animated: false)
    }
}

// MARK: - Private
private extension ProfileNavigationCoordinator {
    func makeStore() -> ProfileStore {
        let store = ProfileStore()
        store.onAction = { [weak self] action in
            switch action {
            case .replayOnboarding:
                self?.showOnboarding()
            case .logout:
                self?.logout()
            }
        }
        return store
    }

    func makeProfileView() -> UIViewController {
        UIHostingController(rootView: ProfileView(store: store))
    }

    func showOnboarding() {
        let coordinator = OnboardingNavigationCoordinator()
        startChildCoordinator(coordinator)
        coordinator.eventPublisher
            .sink { [weak self] event in
                switch event {
                case .dismiss(let coordinator):
                    self?.navigationController.dismiss(animated: true)
                    self?.release(coordinator: coordinator)
                }
            }
            .store(in: &cancellables)
        navigationController.present(coordinator.navigationController, animated: true)
    }

    func logout() {
        try? authManager.signOut()
        eventSubject.send(.loggedOut(self))
    }
}
