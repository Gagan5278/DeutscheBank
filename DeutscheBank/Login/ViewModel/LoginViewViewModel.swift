//
//  LoginViewViewModel.swift
//  DeutscheBank
//
//  Created by Gagan Vishal  on 2023/02/13.
//

import Foundation
import Combine

class LoginViewViewModel {
     
    func validateEnteredUserID(_ userID: AnyPublisher<String, Never>) -> AnyPublisher<Bool, Never> {
        userID
        .map({ $0.integer != nil })
        .eraseToAnyPublisher()
    }
}

