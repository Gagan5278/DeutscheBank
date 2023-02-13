//
//  APIManagerError.swift
//  DeutscheBank
//
//  Created by Gagan Vishal  on 2023/02/11.
//

import Foundation

enum APIManagerError: Error, Equatable {
    case conversionFailedToHTTPURLResponse
    case serilizationFailed
    case urlError(statusCode: Int)
    case somethingWentWrong
    case badURL
}

extension APIManagerError {    
    var showableErrorDescription: String {
        self.errorDescription
    }
    
   private var errorDescription: String {
        switch self {
        case .conversionFailedToHTTPURLResponse:
            return AppConstants.APIError.conversionFailedToHTTPURLResponse
        case .urlError(let code):
            return AppConstants.APIError.somethingWentWrongResponse + "Underlying status code: \(code)"
        case .somethingWentWrong:
            return AppConstants.APIError.somethingWentWrongResponse
        case .serilizationFailed:
            return AppConstants.APIError.serilizationFailedResponse
        case .badURL:
            return AppConstants.APIError.badURLResponse
        }
    }
}
