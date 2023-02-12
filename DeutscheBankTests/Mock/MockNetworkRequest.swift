//
//  MockNetworkRequest.swift
//  DeutscheBankTests
//
//  Created by Gagan Vishal  on 2023/02/11.
//

import Foundation
@testable import DeutscheBank

class MockNetworkRequest: NetworkRequestProtocol {
    var headers: [String : String]?
    
    var bodyParameters: [String : String]?
    
    func callService<T>(with endPoint: DeutscheBank.ServiceEndPointProtocol, model: T.Type, serviceMethod: DeutscheBank.HTTPServiceMethod) async throws -> T where T : Decodable, T : Encodable {
        
    }
}
