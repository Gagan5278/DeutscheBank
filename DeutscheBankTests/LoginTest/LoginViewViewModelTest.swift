//
//  LoginViewViewModelTest.swift
//  DeutscheBankTests
//
//  Created by Gagan Vishal  on 2023/02/13.
//

import XCTest
import Combine
@testable import DeutscheBank

final class LoginViewViewModelTest: XCTestCase {

    private var loginViewModel: LoginViewViewModel!
    private var cancellables: AnyCancellable?
    
    override func setUp() {
        loginViewModel = LoginViewViewModel()
    }

    override func tearDown() {
        loginViewModel = nil
        cancellables = nil
    }

    func testLoginViewModel_WhenValidUserNameEnetered_ShouldReturnTrue() {
        // Given
        let value = "12"
        // When
        let valuePublisher = CurrentValueSubject<String, Never>(value)
            .eraseToAnyPublisher()
        // Then
        cancellables = loginViewModel
            .validateEnteredUserID(valuePublisher)
            .sink(receiveValue: {
                XCTAssertEqual($0, true)
            })
    }
    
    func testLoginViewModel_WhenInvalidUserNameEnetered_ShouldReturnFalse() {
        // Given
        let value = "xx"
        // When
        let valuePublisher = CurrentValueSubject<String, Never>(value)
            .eraseToAnyPublisher()
        // Then
        cancellables = loginViewModel
            .validateEnteredUserID(valuePublisher)
            .sink(receiveValue: {
                XCTAssertEqual($0, false)
            })
    }
}
