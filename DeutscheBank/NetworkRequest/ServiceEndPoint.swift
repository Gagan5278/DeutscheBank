//
//  ServiceEndPoint.swift
//  DeutscheBank
//
//  Created by Gagan Vishal  on 2023/02/11.
//

import Foundation

protocol ServiceEndPointProtocol {
    var requestURLString: String {get}
    var baseURLString: String {get}
}

extension ServiceEndPointProtocol {
    var baseURLString: String {
        AppConstants.APIRequest.baseURL
    }
}

enum ServiceEndPoint: ServiceEndPointProtocol {
    case fetchCommentsForPost(id: Int)
    case fetchPosts
    var requestURLString: String {
          switch self {
          case .fetchCommentsForPost(let id):
              return baseURLString
          case .fetchPosts:
              return baseURLString + "posts"
          }
      }

}
