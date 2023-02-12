//
//  SceneDelegate.swift
//  DeutscheBank
//
//  Created by Gagan Vishal  on 2023/02/11.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        setupNavigationBarAppearance()
        let navController = UINavigationController()
        let coordinator = AppCoordinator(navigationContoller: navController)
        coordinator.start()
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) { }
    
    func sceneDidBecomeActive(_ scene: UIScene) { }
    
    func sceneWillResignActive(_ scene: UIScene) { }
    
    func sceneWillEnterForeground(_ scene: UIScene) { }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        //(UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    // MARK: - Navigationbar appearance
    private func setupNavigationBarAppearance() {
        UINavigationBar.appearance().tintColor = .black
        UINavigationBar.appearance().scrollEdgeAppearance = UINavigationBarAppearance()
    }
    
}
