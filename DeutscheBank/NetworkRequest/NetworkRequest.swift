//
//  NetworkRequest.swift
//  DeutscheBank
//
//  Created by Gagan Vishal  on 2023/02/11.
//

import Foundation
protocol NetworkRequestProtocol {
    var headers: [String: String]? {get set}
    var bodyParameters: [String: String]? {get set}
    func callService<T: Codable>(
        with endPoint: ServiceEndPointProtocol,
        model: T.Type,
        serviceMethod: HTTPServiceMethod
    ) async throws -> T
}

class NetworkRequest: NetworkRequestProtocol {
    var headers: [String: String]?
    var bodyParameters: [String: String]?
    private let apiManager: APIManager
    // MARK: - init
    init() {
        apiManager = APIManager()
    }
    
    func callService<T: Codable>(
        with endPoint: ServiceEndPointProtocol,
        model: T.Type,
        serviceMethod: HTTPServiceMethod
    ) async throws -> T {
        guard let url = URL(string: endPoint.requestURLString) else { throw APIManagerError.badURL }
        let body = try (bodyParameters ?? [:]).serialize()
        return try await apiManager.request(
            url: url,
            httpMethod: serviceMethod,
            body: body,
            headers: bodyParameters,
            expectingReturnType: T.self)
    }
}
