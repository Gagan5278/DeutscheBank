//
//  DeutscheBankUITests.swift
//  DeutscheBankUITests
//
//  Created by Gagan Vishal  on 2023/02/11.
//

import XCTest

final class DeutscheBankUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        app = XCUIApplication()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testLoginViewController_WhenValidUserIDEnetred_MoveToPostListScreen()  {
        app.launch()
        let usernameTextField = app.textFields["Please enter user id (1 to 10)"]
        usernameTextField.tap()
        usernameTextField.typeText("1")
        app.buttons["Login"].tap()
        XCTAssertEqual(app.navigationBars.element.identifier, "My Posts")
    }
    
    func testLoginViewController_WhenInValidUserIDEnetred_DoesNotMoveToPostListScreen()  {
        app.launch()
        let usernameTextField = app.textFields["Please enter user id (1 to 10)"]
        usernameTextField.tap()
        usernameTextField.typeText("t")
        app.buttons["Login"].tap()
        XCTAssertEqual(app.navigationBars.element.identifier, "User Login")
    }

    func testLoginViewController_WhenValidUserIDEnetred_FirstSegmentIsSelectedOnPostListScreen() {
        app.launch()
        let usernameTextField = app.textFields["Please enter user id (1 to 10)"]
        usernameTextField.tap()
        usernameTextField.typeText("1")
        app.buttons["Login"].tap()
        XCTAssertEqual(app.navigationBars.element.identifier, "My Posts")
        XCTAssertTrue(app.segmentedControls.buttons.element(boundBy: 0).isSelected)
    }

    func testLoginViewController_WhenValidUserIDEnetred_SelectFirstPostAndPushToCommentScreen() {
        app.launch()
        let usernameTextField = app.textFields["Please enter user id (1 to 10)"]
        usernameTextField.tap()
        usernameTextField.typeText("1")
        app.buttons["Login"].tap()
        XCTAssertEqual(app.navigationBars.element.identifier, "My Posts")
        XCTAssertTrue(app.segmentedControls.buttons.element(boundBy: 0).isSelected)
    
        if (app.tables.element(boundBy: 0).cells.count > 0) {
            app.tables.element(boundBy: 0).cells.element(boundBy: 0).tap()
        }
        XCTAssertEqual(app.navigationBars.element.identifier, "Comments")
    }
}
