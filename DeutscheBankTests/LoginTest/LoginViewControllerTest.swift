//
//  LoginViewControllerTest.swift
//  DeutscheBankTests
//
//  Created by Gagan Vishal  on 2023/02/13.
//

import XCTest
import Combine
@testable import DeutscheBank

final class LoginViewControllerTest: XCTestCase {

    private var loginViewModel: LoginViewViewModel!
    private var loginViewController: LoginViewController!
    override func setUp() {
        loginViewModel = LoginViewViewModel()
        loginViewController = LoginViewController(viewModel: loginViewModel)
        loginViewController.loadViewIfNeeded()
        loginViewController.viewDidLoad()
    }

    override func tearDown() {
        loginViewModel = nil
        loginViewController = nil
    }

    func testLoginViewController_WhenLoaded_ViewIsNotNil() {
        XCTAssertNotNil(loginViewController.view)
    }

    func testLoginViewController_WhenLoaded_NavigationControllerIsNotNil() {
        XCTAssertNotNil(loginViewController.navigationItem.title)
    }
    
    func testLoginViewController_WhenViewLoaded_LoginButtonHasASelector() {
        let arrSelectors = loginViewController.loginButton.actions(
            forTarget: loginViewController,
            forControlEvent: .touchUpInside
        )
        var selector: String? = nil
        if (arrSelectors?.count ?? 0) > 0 {
            selector = arrSelectors?[0]
        }
        XCTAssert((selector == "nextButtonActionWithSender:"))
    }
    
    func testLoginViewController_WhenTextFieldIsEmpty_LoginButtonIsNotEnabled() {
        XCTAssertFalse(loginViewController.loginButton.isEnabled)
    }
}
