//
//  SceneDelegate.swift
//  Jokes
//
//  Created by Skrivanek, Lukas on 13.05.2026.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let coordinator = AppCoordinator()
        coordinator.start()
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = coordinator.rootViewController
        window.makeKeyAndVisible()
        self.window = window
        appCoordinator = coordinator
    }
}

