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
    private var sutloginViewController: LoginViewController!
    private var mockNavigationController: UINavigationControllerMock!

    override func setUp() {
        loginViewModel = LoginViewViewModel()
        sutloginViewController = LoginViewController(viewModel: loginViewModel)
        sutloginViewController.loadViewIfNeeded()
        sutloginViewController.viewDidLoad()
        mockNavigationController = UINavigationControllerMock(rootViewController: sutloginViewController)
    }

    override func tearDown() {
        loginViewModel = nil
        sutloginViewController = nil
    }

    func testLoginViewController_WhenLoaded_ViewIsNotNil() {
        XCTAssertNotNil(sutloginViewController.view)
    }

    func testLoginViewController_WhenLoaded_NavigationControllerTitleIsNotNil() {
        XCTAssertNotNil(sutloginViewController.navigationItem.title)
    }
    
    func testLoginViewController_ViewLoaded_NavigationTitleShouldBeTitleOfPostListController() {
        XCTAssertNotNil(sutloginViewController.title == AppConstants.LoginScreenConstants.navigationTitle, "Navigation title is wrong")
    }
    
    func testLoginViewController_WhenViewLoaded_LoginButtonHasASelector() {
        //GIVEN
        let arrSelectors = sutloginViewController.loginButton.actions(
            forTarget: sutloginViewController,
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
        XCTAssertFalse(sutloginViewController.loginButton.isEnabled)
    }
    
    func testLoginViewController_WhenTextFieldIsNotEmptyWithValidUserIDInput_LoginButtonIsEnabled() {
        //GIVEN
        let value = "12"
        let valuePublisher = CurrentValueSubject<String, Never>(value)
            .eraseToAnyPublisher()
        // When
        cancellables = loginViewModel
            .validateEnteredUserID(valuePublisher)
            .assign(
                to: \.isEnabled,
                on: sutloginViewController.loginButton
            )
        //Then
        XCTAssertTrue(sutloginViewController.loginButton.isEnabled)
    }
    
    func testLoginViewController_WhenLoginButtonIsEnabled_ButtonTouchUpInsidePushToPostListScreen() {
        //GIVEN
        let value = "12"
        let valuePublisher = CurrentValueSubject<String, Never>(value)
            .eraseToAnyPublisher()
        cancellables = loginViewModel
            .validateEnteredUserID(valuePublisher)
            .assign(
                to: \.isEnabled,
                on: sutloginViewController.loginButton
            )
        XCTAssertTrue(sutloginViewController.loginButton.isEnabled)
        // When
        sutloginViewController.loginButton.sendActions(for: .touchUpInside)
        //Then
        XCTAssertTrue(mockNavigationController.pushViewControllerCalled)
    }
}
