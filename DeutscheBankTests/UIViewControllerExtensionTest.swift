//
//  UIViewControllerExtensionTest.swift
//  DeutscheBankTests
//
//  Created by Gagan Vishal  on 2023/02/12.
//

import XCTest
@testable import DeutscheBank

final class UIViewControllerExtensionTest: XCTestCase {
    private var viewController: TestViewController!

    override func setUp() {
        viewController = TestViewController()
    }

    override func tearDown() {
        viewController = nil
    }

    var keyWindow: UIWindow? {
        // Get connected scenes
         let scenes = UIApplication.shared.connectedScenes
         let windowScene = scenes.first as? UIWindowScene
         let window = windowScene?.windows.first
         return window
    }

    func testWhenAlertPresentedOnUIViewController() {
        let rootWindow = keyWindow
        XCTAssertNotNil(rootWindow, "Root window can't be nil")
        rootWindow!.rootViewController = viewController
        let expectation = expectation(description: "test prestented controller is alert")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: { [weak self] in
            self?.viewController.presentBuyingErrorDialogue()
            XCTAssertTrue(rootWindow!.rootViewController?.presentedViewController is UIAlertController)
          expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1.5)
    }
}

private class TestViewController: UIViewController {
   override func viewDidLoad() {
       super.viewDidLoad()
   }
   
   func presentBuyingErrorDialogue() {
       self.showAlertWith(
           title: "title",
           message: "message",
           firstButtonTitle: "ok",
           firstButtonStyle: .default,
           secondButtonTitle: nil,
           withFirstCallback: nil,
          withSecondCallback: nil)
   }
    
    private func firstButtonAction(action: UIAlertAction) { }
    
 }
