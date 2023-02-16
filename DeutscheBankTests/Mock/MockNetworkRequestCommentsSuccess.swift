//
//  MockNetworkRequestCommentsSuccessTest.swift
//  DeutscheBankTests
//
//  Created by Gagan Vishal  on 2023/02/14.
//

import Foundation
@testable import DeutscheBank

class MockNetworkRequestCommentsSuccess: NetworkRequestProtocol {
    var headers: [String : String]?
    var bodyParameters: [String : String]?
    private let commentsModel: [CommentModel]  = JSONLoader.load("Comments.json")
    
    func callService<T>(with endPoint: DeutscheBank.ServiceEndPointProtocol, model: T.Type, serviceMethod: DeutscheBank.HTTPServiceMethod) async throws -> T where T : Codable {
        return commentsModel as! T
    }
}
