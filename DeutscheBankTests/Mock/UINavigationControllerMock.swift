//
//  UINavigationControllerMock.swift
//  DeutscheBankTests
//
//  Created by Gagan Vishal  on 2023/02/12.
//

import Foundation
final class UINavigationControllerMock: UINavigationController {
    var pushViewControllerCalled = false
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool ) {
        super.pushViewController(viewController, animated: animated)
        pushViewControllerCalled = true
    }
}
