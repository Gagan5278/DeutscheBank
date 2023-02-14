//
//  CommentsViewViewModel.swift
//  DeutscheBank
//
//  Created by Gagan Vishal  on 2023/02/13.
//

import Foundation
import Combine

class CommentsViewViewModel {
    
    public private(set) var commentOutput: PassthroughSubject<CommentOutput, Never> = .init()
    private var comments: [CommentsViewViewModelItemProtocol] = []
    private let commentServiceRequest: NetworkRequestProtocol
    private let selectedPost: PostViewModelItemProtocol
    init(request: NetworkRequestProtocol, post: PostViewModelItemProtocol) {
        commentServiceRequest = request
        selectedPost = post
        loadCommentssFromServerFor(post: post)
    }
    
    private func loadCommentssFromServerFor(post: PostViewModelItemProtocol) {
        Task {
            do {
                let commentsRecieved = try await self.commentServiceRequest.callService(
                    with: ServiceEndPoint.fetchCommentsForPost(id: post.postID),
                    model: [CommentModel].self,
                    serviceMethod: .get
                )
                if commentsRecieved.isEmpty {
                    commentOutput.send(.fetchCommentssDidSucceedWithEmptyList)
                } else {
                    createCommetModelsFromRecieved(rawComments: commentsRecieved)
                    commentOutput.send(.fetchCommentsDidSucceed)
                }
            } catch {
                commentOutput.send(.didFailToFetchComments)
            }
        }
    }
    
    var numberOfRowsInCommentTableView: Int {
        comments.count
    }
    
    func getPostComment(at indexPath: IndexPath) -> CommentsViewViewModelItemProtocol {
        comments[indexPath.row]
    }
    
    var isFavoritePost: Bool {
        selectedPost.isFavoritePost
    }
    
    var selectedPostTitle: String {
        selectedPost.postTitle
    }
    
    var selectedPostBody: String {
        selectedPost.postBody
    }
}

// MARK: - Private section
extension CommentsViewViewModel {
    private func createCommetModelsFromRecieved(rawComments: [CommentModel]) {
        comments = rawComments.map ({ CommentsViewViewModelItem(comment: $0) })
    }
}

extension CommentsViewViewModel {
    enum CommentOutput {
        case fetchCommentsDidSucceed
        case didFailToFetchComments
        case fetchCommentssDidSucceedWithEmptyList
    }
}
