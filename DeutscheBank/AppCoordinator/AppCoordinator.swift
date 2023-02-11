//
//  AppCoordinator.swift
//  DeutscheBank
//
//  Created by Gagan Vishal  on 2023/02/11.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController {get set}
    func start()
    func pushToShowPostsFor(userID: Int)
}

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    // MARK: - init
    init(navigationContoller: UINavigationController) {
        self.navigationController = navigationContoller
    }
    
    func start() {
        let loginViewController = LoginViewController()
        loginViewController.loginCoordinator = self
        loginViewController.view.backgroundColor = .white
        navigationController.pushViewController(loginViewController, animated: true)
    }
    
    func pushToShowPostsFor(userID: Int) {
        let userModel = LoginUserModel(userid: userID)
    }
}
