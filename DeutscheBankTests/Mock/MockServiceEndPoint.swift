//
//  MockServiceEndPoint.swift
//  DeutscheBankTests
//
//  Created by Gagan Vishal  on 2023/02/11.
//

import Foundation
@testable import DeutscheBank

enum MockServiceEndPoint: ServiceEndPointProtocol {
    case fetchCommentsForPost(id: Int)
    case fetchPostsForUser(id: Int)
    var requestURLString: String { "https://some.fake.url" }
}
