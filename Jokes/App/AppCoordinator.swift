import Combine
import Dependencies
import UIKit

protocol AppCoordinating: ViewControllerCoordinator {}

final class AppCoordinator: AppCoordinating {
    private(set) var rootViewController: UIViewController = UIViewController()
    var childCoordinators = [Coordinator]()
    var window: UIWindow?

    private var cancellables = Set<AnyCancellable>()
    @Dependency(\.authManager) private var authManager

    private var isAuthorized: Bool {
        authManager.isSignedIn
    }

    func start() {
        setupGlobalAppearance()
        if isAuthorized {
            showTabBar()
            DispatchQueue.main.async { [weak self] in
                self?.showOnboardingIfNeeded()
            }
        } else {
            showLogin()
        }
    }
}

// MARK: - Private
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

    func showLogin() {
        let coordinator = LoginNavigationCoordinator()
        startChildCoordinator(coordinator)
        coordinator.eventPublisher
            .sink { [weak self] event in
                switch event {
                case .loggedIn(let coordinator):
                    self?.release(coordinator: coordinator)
                    self?.showTabBar()
                    self?.showOnboardingIfNeeded()
                }
            }
            .store(in: &cancellables)
        transition(to: coordinator.navigationController)
    }

    func showTabBar() {
        let coordinator = MainTabBarCoordinator()
        startChildCoordinator(coordinator)
        coordinator.eventPublisher
            .sink { [weak self] event in
                switch event {
                case .loggedOut(let coordinator):
                    self?.release(coordinator: coordinator)
                    self?.showLogin()
                }
            }
            .store(in: &cancellables)
        transition(to: coordinator.rootViewController)
    }

    func showOnboardingIfNeeded() {
        guard !UserDefaults.standard.bool(forKey: "hasSeenOnboarding") else { return }
        let coordinator = OnboardingNavigationCoordinator()
        startChildCoordinator(coordinator)
        coordinator.eventPublisher
            .sink { [weak self] event in
                switch event {
                case .dismiss(let coordinator):
                    UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                    self?.rootViewController.dismiss(animated: true)
                    self?.release(coordinator: coordinator)
                }
            }
            .store(in: &cancellables)
        rootViewController.present(coordinator.navigationController, animated: true)
    }

    func transition(to viewController: UIViewController) {
        rootViewController = viewController
        guard let window else { return }
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve) {
            window.rootViewController = viewController
        }
    }
}
