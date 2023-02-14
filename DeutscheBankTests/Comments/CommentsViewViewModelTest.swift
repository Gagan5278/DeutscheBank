//
//  CommentsViewViewModelTest.swift
//  DeutscheBankTests
//
//  Created by Gagan Vishal  on 2023/02/14.
//

import XCTest
import Combine
@testable import DeutscheBank

final class CommentsViewViewModelTest: XCTestCase {

    private var sutCommentsViewViewModel: CommentsViewViewModel!
    private var cancellable = Set<AnyCancellable>()
    private var mockPostViewModelItem: PostViewModelItemProtocol!
    private var mockRequest: MockNetworkRequestCommentsSuccess!

    override func setUp() {
        let mockModels: [PostModel] = JSONLoader.load("Posts.json")
        mockPostViewModelItem = PostViewModelItem(postModel: mockModels.first!)
        mockRequest = MockNetworkRequestCommentsSuccess()
        sutCommentsViewViewModel = CommentsViewViewModel(
            request: mockRequest,
            post: mockPostViewModelItem
        )
    }

    override func tearDown() {
        mockPostViewModelItem = nil
        mockRequest = nil
        sutCommentsViewViewModel = nil
    }

    func testCommentsViewViewModel_WhenCommentsLoaded_NumberOfRowsSouldBeMoreThanZero()  {
        let comments = sutCommentsViewViewModel!
        comments.commentOutput
            .sink { output in
                XCTAssertTrue(output == .fetchCommentsDidSucceed)
                XCTAssertTrue(comments.numberOfRowsInCommentTableView > 0)
            }
            .store(in: &cancellable)
    }
    
    func testCommentsViewViewModel_WhenCommentsLoaded_GetPostCommentHasSamePostID()  {
        let comments = sutCommentsViewViewModel!
        comments.commentOutput
            .sink { [weak self] output in
                guard let self = self else { return }
                XCTAssertTrue(output == .fetchCommentsDidSucceed)
                XCTAssertTrue(comments.getPostComment(at: IndexPath(row: 0, section: 0)).postId == self.mockPostViewModelItem.postID)
            }
            .store(in: &cancellable)
    }
    
    func testCommentsViewViewModel_WhenCommentsLoadingFailed_ShouldReturnDidFailToFetchComments()  {
        let comments = CommentsViewViewModel(
            request: MockNetworkRequestCommentsFailure(),
            post: mockPostViewModelItem
        )
        comments.commentOutput
            .sink { output  in
                XCTAssertTrue(output == .didFailToFetchComments)
            }
            .store(in: &cancellable)
    }
}
