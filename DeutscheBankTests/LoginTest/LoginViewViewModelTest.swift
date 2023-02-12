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
    private var cancellables = Set<AnyCancellable>()
    override func setUp() {
        loginViewModel = LoginViewViewModel()
    }

    override func tearDown() {
        loginViewModel = nil
    }

    func testLoginViewModel_WhenValidUserNameEnetered_ShouldReturnTrue() {
        let value = "12"
        let valuePublisher = CurrentValueSubject<String, Never>(value).eraseToAnyPublisher()
        loginViewModel
            .validateEnteredUserID(valuePublisher)
            .sink(receiveValue: {
                XCTAssertEqual($0, true)
            })
            .store(in: &cancellables)
    }
    
    func testLoginViewModel_WhenInvalidUserNameEnetered_ShouldReturnFalse() {
        let value = "xx"
        let valuePublisher = CurrentValueSubject<String, Never>(value).eraseToAnyPublisher()
        loginViewModel
            .validateEnteredUserID(valuePublisher)
            .sink(receiveValue: {
                XCTAssertEqual($0, false)
            })
            .store(in: &cancellables)
    }
}
