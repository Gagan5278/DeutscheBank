//
//  CommentsViewViewModelItem.swift
//  DeutscheBank
//
//  Created by Gagan Vishal  on 2023/02/13.
//

import Foundation

protocol CommentsViewViewModelItemProtocol {
    var commenterEmail: String { get }
    var commenterName: String { get }
    var comment: String { get }
}

struct CommentsViewViewModelItem: CommentsViewViewModelItemProtocol {
    var commenterEmail: String {
        commentModel.email.lowercased()
    }
    
    var commenterName: String {
        commentModel.name.capitalizeFirstLetterOfSentence
    }
    
    var comment: String {
        commentModel.body.capitalizeFirstLetterOfSentence
    }
        
    let commentModel: CommentModel
    
    // MARK: - init
    init(comment: CommentModel) {
        commentModel = comment
    }
}
