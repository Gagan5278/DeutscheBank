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
    var postID: Int {get}
    var isFavoritePost: Bool {get set}
    func updatePostStatus(post: PostModel, isFavorite: Bool) -> PostViewModelItemProtocol
}

struct PostViewModelItem: PostViewModelItemProtocol {
    var isFavoritePost: Bool = false
    
    var postTitle: String {
        postModel.title.capitalizeFirstLetterOfSentence
    }
    
    var postBody: String {
        postModel.body.capitalizeFirstLetterOfSentence
    }
    
    var postID: Int {
        postModel.id
    }

    var userID: Int {
        postModel.userId
    }
    
    private let postModel: PostModel
    // MARK: - init
    init(postModel: PostModel, isFavorite: Bool = false) {
        self.postModel = postModel
        isFavoritePost = isFavorite
    }
    
    func updatePostStatus(post: PostModel, isFavorite: Bool) -> PostViewModelItemProtocol {
        PostViewModelItem(postModel: post, isFavorite: isFavorite)
    }
}
