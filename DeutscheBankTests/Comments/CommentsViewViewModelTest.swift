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
    
    func testCommentsViewViewModel_WhenCommentsLoaded_NumberOfRowsSouldBeMoreThanZero() async throws  {
        let expectation = expectation(description: "NumberOfRowsSouldBeMoreThanZero")
        let task = sutCommentsViewViewModel.fetchCommentsTaskForSelectedPost()
        let posts = try await task.value
        XCTAssertNotNil(posts)
        XCTAssertTrue(posts!.count > 0)
        sutCommentsViewViewModel
            .commentRequestOutput
            .sink { output in
                XCTAssertTrue(output == .fetchCommentsDidSucceed)
                XCTAssertTrue(self.sutCommentsViewViewModel.numberOfRowsInCommentTableView > 0)
                expectation.fulfill()
            }
            .store(in: &cancellable)
        try await sutCommentsViewViewModel.readCommentsFromRecieved(task: task)
        wait(for: [expectation], timeout: 5)
    }
    
    func testCommentsViewViewModel_WhenCommentsLoaded_GetPostCommentHasSamePostID() async throws {
        let expectation = expectation(description: "GetPostCommentHasSamePostID")
        let task = sutCommentsViewViewModel.fetchCommentsTaskForSelectedPost()
        let posts = try await task.value
        XCTAssertNotNil(posts)
        XCTAssertTrue(posts!.count > 0)
        sutCommentsViewViewModel.commentRequestOutput
            .sink { [weak self] output in
                guard let self = self else { return }
                XCTAssertTrue(output == .fetchCommentsDidSucceed)
                XCTAssertTrue(self.sutCommentsViewViewModel.getComment(at: IndexPath(row: 0, section: 0)).postId == self.mockPostViewModelItem.postID)
                expectation.fulfill()
            }
            .store(in: &cancellable)
        try await sutCommentsViewViewModel.readCommentsFromRecieved(task: task)
        wait(for: [expectation], timeout: 5)
    }
    
    func testCommentsViewViewModel_WhenCommentsLoadingFailed_ShouldReturnDidFailToFetchComments() async throws {
        let expectation = expectation(description: "ShouldReturnDidFailToFetchComments")
        sutCommentsViewViewModel = nil
        sutCommentsViewViewModel = CommentsViewViewModel(
            request: MockNetworkRequestCommentsFailure(),
            post: mockPostViewModelItem
        )
        let task = sutCommentsViewViewModel.fetchCommentsTaskForSelectedPost()
        let posts = try await task.value
        XCTAssertNil(posts)
        sutCommentsViewViewModel.commentRequestOutput
            .sink { output  in
                XCTAssertTrue(output == .didFailToFetchComments)
                expectation.fulfill()
            }
            .store(in: &cancellable)
        try await sutCommentsViewViewModel.readCommentsFromRecieved(task: task)
        wait(for: [expectation], timeout: 5)
    }
}
