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
    private var mockPostViewModelItem: PostViewModelItemProtocol = {
        let mockModels: [PostModel] = JSONLoader.load("Posts.json")
        return PostViewModelItem(postModel: mockModels.first!)
    }()
    private let mockRequest: MockNetworkRequestCommentsSuccess = MockNetworkRequestCommentsSuccess()
    
    override func setUp() {
        sutCommentsViewViewModel = CommentsViewViewModel(
            request: mockRequest,
            post: mockPostViewModelItem
        )
    }
    
    override func tearDown() {
        sutCommentsViewViewModel = nil
        cancellable = []
    }
    
    func testCommentsViewViewModel_WhenCommentsLoaded_NumberOfRowsSouldBeMoreThanZero()  {
        sutCommentsViewViewModel.commentOutput
            .sink { output in
                XCTAssertTrue(output == .fetchCommentsDidSucceed)
                XCTAssertTrue(self.sutCommentsViewViewModel.numberOfRowsInCommentTableView > 0)
            }
            .store(in: &cancellable)
    }
    
    func testCommentsViewViewModel_WhenCommentsLoaded_GetPostCommentHasSamePostID()  {
        sutCommentsViewViewModel.commentOutput
            .sink { [weak self] output in
                guard let self = self else { return }
                XCTAssertTrue(output == .fetchCommentsDidSucceed)
                XCTAssertTrue(self.sutCommentsViewViewModel.getPostComment(at: IndexPath(row: 0, section: 0)).postId == self.mockPostViewModelItem.postID)
            }
            .store(in: &cancellable)
    }
    
    func testCommentsViewViewModel_WhenCommentsLoadingFailed_ShouldReturnDidFailToFetchComments()  {
        sutCommentsViewViewModel = nil
        sutCommentsViewViewModel = CommentsViewViewModel(
            request: MockNetworkRequestCommentsFailure(),
            post: mockPostViewModelItem
        )
        sutCommentsViewViewModel.commentOutput
            .sink { output  in
                XCTAssertTrue(output == .didFailToFetchComments)
            }
            .store(in: &cancellable)
    }
}
