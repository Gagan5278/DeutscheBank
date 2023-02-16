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
    case fetchPostsForUser(id: Int)
    var requestURLString: String {
          switch self {
          case .fetchCommentsForPost(_):
              return baseURLString + path
          case .fetchPostsForUser(_):
              return baseURLString + path
          }
      }
    
    var path: String {
        switch self {
        case .fetchCommentsForPost(let id):
            return "post/\(id)/comments"
        case .fetchPostsForUser(let userID):
            return "posts?userId=\(userID)"
        }
    }
}
