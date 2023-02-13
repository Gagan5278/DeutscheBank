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
    let commentServiceRequest: NetworkRequestProtocol
    init(request: NetworkRequestProtocol, post: PostViewModelItemProtocol) {
        commentServiceRequest = request
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
