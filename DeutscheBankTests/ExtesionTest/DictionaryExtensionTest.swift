//
//  DictionaryExtensionTest.swift
//  DeutscheBankTests
//
//  Created by Gagan Vishal  on 2023/02/15.
//

import XCTest
@testable import DeutscheBank

final class DictionaryExtensionTest: XCTestCase {
    
    override func setUp()  { }
    
    override func tearDown() { }
    
    func testDictionarySerialize_WhenValidDictionaryPassed_ShouldNotBeNilData()  {
        let validDictionary = ["name": "test name", "age" : 1223] as [String : Any]
        do {
            let data = try validDictionary.serialize()
            XCTAssertNotNil(data)
        } catch {
            XCTFail()
        }
    }
}
