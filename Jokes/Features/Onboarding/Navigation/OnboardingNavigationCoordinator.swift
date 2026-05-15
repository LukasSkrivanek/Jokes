import Combine
import SwiftUI
import UIKit

enum OnboardingCoordinatorEvent {
    case dismiss(Coordinator)
}

final class OnboardingNavigationCoordinator: NSObject, NavigationControllerCoordinator, EventEmitting {
    typealias Event = OnboardingCoordinatorEvent

    private(set) lazy var navigationController: UINavigationController = {
        let nav = CustomNavigationController()
        nav.modalPresentationStyle = .fullScreen
        nav.modalTransitionStyle = .crossDissolve
        return nav
    }()

    var childCoordinators = [Coordinator]()
    private let eventSubject = PassthroughSubject<OnboardingCoordinatorEvent, Never>()
    private var cancellables = Set<AnyCancellable>()
    private let store = OnboardingStore()

    var eventPublisher: AnyPublisher<OnboardingCoordinatorEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }

    func start() {
        observeStore()
        navigationController.setViewControllers(
            [makeViewController(for: .welcome)],
            animated: false
        )
    }
}

// MARK: - Private
private extension OnboardingNavigationCoordinator {
    func observeStore() {
        store.$state
            .map(\.currentPage)
            .removeDuplicates()
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] pageIndex in
                guard let page = OnboardingStore.Page(rawValue: pageIndex) else { return }
                self?.navigationController.pushViewController(
                    self?.makeViewController(for: page) ?? UIViewController(),
                    animated: true
                )
            }
            .store(in: &cancellables)

        store.$state
            .map(\.isCompleted)
            .filter { $0 }
            .first()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                eventSubject.send(.dismiss(self))
            }
            .store(in: &cancellables)
    }

    func makeViewController(for page: OnboardingStore.Page) -> UIViewController {
        UIHostingController(rootView: OnboardingView(page: page, store: store))
    }
}
