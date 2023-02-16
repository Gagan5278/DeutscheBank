//
//  DeutscheBankUITestsLaunchTests.swift
//  DeutscheBankUITests
//
//  Created by Gagan Vishal  on 2023/02/11.
//

import XCTest

final class DeutscheBankUITestsLaunchTests: XCTestCase {
    
    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    func testAppLaunchScreen() throws {
        let app = XCUIApplication()
        app.launch()
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
