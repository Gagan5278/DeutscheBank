//
//  CommentModel.swift
//  DeutscheBank
//
//  Created by Gagan Vishal  on 2023/02/13.
//

import Foundation

struct CommentModel: Codable {
    let postId: Int
    let id: Int
    let name: String
    let body: String
    let email: String
}
