//
//  StringExtensionTest.swift
//  DeutscheBankTests
//
//  Created by Gagan Vishal  on 2023/02/12.
//

import XCTest
@testable import DeutscheBank

final class StringExtensionTest: XCTestCase {

    override func setUp() { }

    override func tearDown() { }

    func testStringExtension_WhenValidIntegerInString_RetrunNotNil()  {
      let numberString = "123"
      XCTAssertNotNil(numberString.integer)
    }

    func testStringExtension_WhenInvalidIntegerInString_RetrunNil()  {
      let numberString = "Hi123"
      XCTAssertNil(numberString.integer)
    }

}
