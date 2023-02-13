//
//  PostModel.swift
//  DeutscheBank
//
//  Created by Gagan Vishal  on 2023/02/11.
//

import Foundation

struct PostModel: Codable {
    var userId: Int
    var id: Int
    var title: String
    var body: String
}
