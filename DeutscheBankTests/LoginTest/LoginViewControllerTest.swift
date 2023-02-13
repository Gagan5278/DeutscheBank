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
    private var cancellables: AnyCancellable?

    private var loginViewModel: LoginViewViewModel!
    private var loginViewController: LoginViewController!
    private var mockNavigationController: UINavigationControllerMock!

    override func setUp() {
        loginViewModel = LoginViewViewModel()
        loginViewController = LoginViewController(viewModel: loginViewModel)
        loginViewController.loadViewIfNeeded()
        loginViewController.viewDidLoad()
        mockNavigationController = UINavigationControllerMock(rootViewController: loginViewController)
    }

    override func tearDown() {
        loginViewModel = nil
        loginViewController = nil
    }

    func testLoginViewController_WhenLoaded_ViewIsNotNil() {
        XCTAssertNotNil(loginViewController.view)
    }

    func testLoginViewController_WhenLoaded_NavigationControllerTitleIsNotNil() {
        XCTAssertNotNil(loginViewController.navigationItem.title)
    }
    
    func testLoginViewController_WhenViewLoaded_LoginButtonHasASelector() {
        //GIVEN
        let arrSelectors = loginViewController.loginButton.actions(
            forTarget: loginViewController,
            forControlEvent: .touchUpInside
        )
        // When
        var selector: String? = nil
        if (arrSelectors?.count ?? 0) > 0 {
            selector = arrSelectors?[0]
        }
        //Then
        XCTAssert(selector == "nextButtonActionWithSender:")
    }
    
    func testLoginViewController_WhenTextFieldIsEmpty_LoginButtonIsNotEnabled() {
        XCTAssertFalse(loginViewController.loginButton.isEnabled)
    }
    
    func testLoginViewController_WhenTextFieldIsNotEmptyWithValidUserIDInput_LoginButtonIsEnabled() {
        //GIVEN
        let value = "12"
        let valuePublisher = CurrentValueSubject<String, Never>(value)
            .eraseToAnyPublisher()
        // When
        cancellables = loginViewModel.validateEnteredUserID(valuePublisher)
            .assign(to: \.isEnabled, on: loginViewController.loginButton)
        //Then
        XCTAssertTrue(loginViewController.loginButton.isEnabled)
    }
    
    func testLoginViewController_WhenLoginButtonIsEnabled_ButtonTouchUpInsidePushToPostListScreen() {
        //GIVEN
        let value = "12"
        let valuePublisher = CurrentValueSubject<String, Never>(value)
            .eraseToAnyPublisher()
        cancellables = loginViewModel.validateEnteredUserID(valuePublisher)
            .assign(to: \.isEnabled, on: loginViewController.loginButton)
        XCTAssertTrue(loginViewController.loginButton.isEnabled)
        // When
        loginViewController.loginButton.sendActions(for: .touchUpInside)
        //Then
        XCTAssertTrue(mockNavigationController.pushViewControllerCalled)
    }
}
