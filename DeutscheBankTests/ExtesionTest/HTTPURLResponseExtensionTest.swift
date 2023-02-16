//
//  HTTPURLResponseExtensionTest.swift
//  DeutscheBankTests
//
//  Created by Gagan Vishal  on 2023/02/15.
//

import XCTest
@testable import DeutscheBank
final class HTTPURLResponseExtensionTest: XCTestCase {

    override func setUp() { }

    override func tearDown() { }

    func testHTTPURLResponseChecker_WhenValidResponseSupplied_ShouldBeTrueInTryBlock()  {
        let urlResponse = HTTPURLResponse(url: URL(string: "https://google.com/")!, statusCode: 244, httpVersion: nil, headerFields: nil)
        do {
            try urlResponse!.statusCodeChecker()
            XCTAssert(true, "Valid status code check success")
        } catch {
            XCTFail()
        }
    }

    func testHTTPURLResponseChecker_WhenInValidResponseSupplied_ShouldBeTrueInCatchBlock()  {
        let urlResponse = HTTPURLResponse(url: URL(string: "https://google.com/")!, statusCode: 344, httpVersion: nil, headerFields: nil)
        do {
            try urlResponse!.statusCodeChecker()
            XCTFail("Should fail due to bad status code")
        } catch {
            XCTAssert(true, "Invalid code check success")
        }
    }
}
