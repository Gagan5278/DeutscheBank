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
    
    // MARK: - init
    init(request: NetworkRequestProtocol, post: PostViewModelItemProtocol) {
        commentServiceRequest = request
        selectedPost = post
    }
    
    func fetchCommentsTaskForSelectedPost() -> Task<[CommentModel]?, Error> {
        return Task {
            try? await self.commentServiceRequest.callService(
                with: ServiceEndPoint.fetchCommentsForPost(id: selectedPost.postID),
                model: [CommentModel].self,
                serviceMethod: .get
            )
        }
    }
    
    func readCommentsFromRecieved(task: Task<[CommentModel]?, Error>) async throws  {
        if let commentsRecieved = try? await task.value {
            if commentsRecieved.isEmpty {
                commentOutput.send(.fetchCommentssDidSucceedWithEmptyList)
            } else {
                createCommetModelsFromRecieved(rawComments: commentsRecieved)
                commentOutput.send(.fetchCommentsDidSucceed)
            }
        } else {
            commentOutput.send(.didFailToFetchComments)
        }
    }

    func loadCommentsFromServer() {
         Task {
             let task = fetchCommentsTaskForSelectedPost()
             try await readCommentsFromRecieved(task: task)
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
