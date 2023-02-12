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
    func pushToShowCommentScreen(for post: PostViewModelItemProtocol)
    func popToLastScreen()
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
        loginViewController.view.backgroundColor = .appBackgroundColor
        navigationController.pushViewController(loginViewController, animated: true)
    }
    
    func pushToShowPostsFor(userID: Int) {
        let userModel = LoginUserModel(userid: userID)
        let postListViewController = PostListViewController(viewModel: PostsViewViewModel(request: NetworkRequest(), user: userModel))
        postListViewController.view.backgroundColor = .appBackgroundColor
        postListViewController.postListCoordinator = self
        navigationController.pushViewController(postListViewController, animated: true)
    }
    
    func pushToShowCommentScreen(for post: PostViewModelItemProtocol) {
        
    }

    func popToLastScreen() {
        navigationController.popViewController(animated: true)
    }
}
