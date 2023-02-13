//
//  NetworkRequestTest.swift
//  DeutscheBankTests
//
//  Created by Gagan Vishal  on 2023/02/11.
//

import XCTest
@testable import DeutscheBank

final class NetworkRequestTest: XCTestCase {
    
    var mockNetworkRequestFailureTest: MockNetworkRequestFailureTest!
    var mockNetworkRequestSuccessTest: MockNetworkRequestSuccessTest!
    
    override func setUp() {
        mockNetworkRequestFailureTest = MockNetworkRequestFailureTest()
        mockNetworkRequestSuccessTest = MockNetworkRequestSuccessTest()
    }
    
    override func tearDown() {
        mockNetworkRequestFailureTest = nil
        mockNetworkRequestSuccessTest = nil
    }
    
    func testNetworkRequest_WhenAnErrorOccured_ShouldFailWithError() async {
        do {
            _ =  try await mockNetworkRequestFailureTest.callService(
                with: MockServiceEndPoint.fetchPostsForUser(id: 0),
                model: [PostModel].self,
                serviceMethod: .get)
            XCTFail("Expected to throw while awaiting, but succeeded")
        } catch {
            XCTAssertEqual(error as? APIManagerError, .somethingWentWrong)
        }
    }
    
    func testNetworkRequest_WhenPostDataLoaded_ShouldSuccessWithNonEmptyModels() async throws {
        let models =  try await mockNetworkRequestSuccessTest.callService(
            with: MockServiceEndPoint.fetchPostsForUser(id: 0),
            model: [PostModel].self,
            serviceMethod: .get)
        XCTAssertTrue(!models.isEmpty)
    }
}
