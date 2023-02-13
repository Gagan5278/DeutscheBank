//
//  MockNetworkRequestSuccessTest.swift
//  DeutscheBankTests
//
//  Created by Gagan Vishal  on 2023/02/13.
//

import Foundation
@testable import DeutscheBank

class MockNetworkRequestSuccessTest: NetworkRequestProtocol {
    var headers: [String : String]?
    var bodyParameters: [String : String]?
    private let postsModel: [PostModel]  = JSONLoader.load("Posts.json")

    func callService<T>(with endPoint: DeutscheBank.ServiceEndPointProtocol, model: T.Type, serviceMethod: DeutscheBank.HTTPServiceMethod) async throws -> T where T : Codable {
        return postsModel as! T
    }
}
