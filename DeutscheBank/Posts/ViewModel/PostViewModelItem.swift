//
//  PostViewModelItem.swift
//  DeutscheBank
//
//  Created by Gagan Vishal  on 2023/02/11.
//

import Foundation

/*
 This entity can be used to modify/update raw data coming from codable model.
 Example:
   if we get 'firstName' and 'secondName' from model.
   Here we can get 'fullName' by adding business logic in this file.
 */


protocol PostViewModelItemProtocol {
    var postTitle: String {get}
    var postBody: String {get}
    var userID: Int {get}
}

struct PostViewModelItem: PostViewModelItemProtocol {
    var postTitle: String {
        postModel.title
    }
    
    var postBody: String {
        postModel.body
    }

    var userID: Int {
        postModel.userId
    }
    
    private let postModel: PostModel
    init(postModel: PostModel) {
        self.postModel = postModel
    }
}
