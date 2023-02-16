//
//  MockNetworkRequestSuccessWithEmptyModelTest.swift
//  DeutscheBankTests
//
//  Created by Gagan Vishal  on 2023/02/13.
//

import Foundation
@testable import DeutscheBank

class MockNetworkRequestPostSuccessWithEmptyModel: NetworkRequestProtocol {
    var headers: [String: String]?
    var bodyParameters: [String: String]?
    
    func callService<T>(with
                        endPoint: DeutscheBank.ServiceEndPointProtocol,
                        model: T.Type,
                        serviceMethod: DeutscheBank.HTTPServiceMethod
    ) async throws -> T where T: Codable {
        return [] as! T
    }
}
