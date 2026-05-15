import Combine
import UIKit

protocol AppCoordinating: ViewControllerCoordinator {}

final class AppCoordinator: AppCoordinating {
    private(set) lazy var rootViewController: UIViewController = makeTabBarFlow()
    var childCoordinators = [Coordinator]()
    private var cancellables = Set<AnyCancellable>()

    func start() {
        setupGlobalAppearance()
        DispatchQueue.main.async { [weak self] in
            self?.showOnboardingIfNeeded()
        }
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
}
