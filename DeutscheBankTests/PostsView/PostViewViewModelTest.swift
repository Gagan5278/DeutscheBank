//
//  PostViewViewModelTest.swift
//  DeutscheBankTests
//
//  Created by Gagan Vishal  on 2023/02/12.
//
import XCTest
import Combine
@testable import DeutscheBank

final class PostViewViewModelTest: XCTestCase {
    
    private var cancellable = Set<AnyCancellable>()
    private let mockUser = LoginUserModel(userid: 1)
    private let coreDataManager = CoreDataStackInMemory()
    private var postViewModel: PostsViewViewModel!
    
    override func setUp() { }
    
    override func tearDown() {
         postViewModel = nil
    }
    
    private func setupPostViewViewModel()  {
        postViewModel = PostsViewViewModel(
            request: MockNetworkRequestSuccessTest(),
            user: mockUser, codeDataManager: coreDataManager
        )
    }
    
    func testPostsViewViewModel_WhenPostModelLoaded_NumberOfRowsSouldBeMoreThanZero()  {
        setupPostViewViewModel()
        let expectation = self.expectation(description: "testPostsViewViewModel_WhenPostModelLoaded_NumberOfRowsSouldBeMoreThanZero")
        postViewModel.requestOutput
            .sink { [weak self] output in
                expectation.fulfill()
                guard let self = self else {return}
                XCTAssertTrue(output == .fetchPostsDidSucceed)
                XCTAssertTrue(self.postViewModel.numberOfRowsInPostTableView > 0)
            }
            .store(in: &cancellable)
        waitForExpectations(timeout: 10)
    }
    
    func testPostsViewViewModel_WhenPostModelLoadingFailed_ShouldReturnFetchPostsDidFail() {
        //Given
        let expectation = self.expectation(description: "testPostsViewViewModel_WhenPostModelLoadingFailed_ShouldReturnFetchPostsDidFail")
        let failedPostViewModel =  PostsViewViewModel(
            request: MockNetworkRequestFailureTest(),
            user: mockUser,
            codeDataManager: coreDataManager
        )
        // When
      failedPostViewModel.requestOutput
            .receive(on: RunLoop.main)
            .sink { output in
                // Then
                expectation.fulfill()
                XCTAssertTrue(output == .fetchPostsDidFail)
            }
            .store(in: &cancellable)

        waitForExpectations(timeout: 5)
    }
    
    func testPostsViewViewModel_WhenPostModelLoadingFailed_ShouldReturnFetchPostsDidSucceedWithEmptyList() {
        //Given
        let expectation = self.expectation(description: "testPostsViewViewModel_WhenPostModelLoadingFailed_ShouldReturnFetchPostsDidSucceedWithEmptyList")
        let emptyPostViewModel =  PostsViewViewModel(
            request: MockNetworkRequestSuccessWithEmptyModelTest(),
            user: mockUser,
            codeDataManager: coreDataManager
        )
        // When
       emptyPostViewModel.requestOutput
            .receive(on: RunLoop.main)
            .sink { output in
                // Then
                XCTAssertTrue(output == .fetchPostsDidSucceedWithEmptyList)
                expectation.fulfill()
            }
            .store(in: &cancellable)

        waitForExpectations(timeout: 5)
    }
    
    func testPostsViewViewModel_WhenPostModelLoaded_GetPostAtGivenIndexPathMustHaveEqualPostID() {
        let expectation = self.expectation(description: "testPostsViewViewModel_WhenPostModelLoaded_GetPostAtGivenIndexPathMustHaveEqualPostID")
        setupPostViewViewModel()
        postViewModel.requestOutput.sink { [weak self] output in
            print(output == .reloadPost)
            let post = self?.postViewModel.getPost(at: IndexPath(row: 0, section: 0))
            let postModel: [PostModel] = JSONLoader.load("Posts.json")
            XCTAssertTrue(post!.postID == postModel[0].id)
            expectation.fulfill()
        }
        .store(in: &cancellable)
        waitForExpectations(timeout: 5)
    }
    
    func testPostsViewViewModel_WhenPostModelLoadedUpdatePostStatusToFavorite_ShouldHaveFavoriteTrue() {
       // Given
        let expectation = self.expectation(description: "testPostsViewViewModel_WhenPostModelLoadedUpdatePostStatusToFavorite_ShouldHaveFavoriteTrue")
        setupPostViewViewModel()
        let userInput: PassthroughSubject<PostsViewViewModel.UserInput, Never> = .init()
        let postModel: [PostModel]  = JSONLoader.load("Posts.json")
        let output = postViewModel.transform(input: userInput.eraseToAnyPublisher())
        // Then
        output.sink { req in
            print(req)
            expectation.fulfill()
            XCTAssertTrue(req == .reloadPost)
            let post = self.postViewModel.getPost(at: IndexPath(row: 0, section: 0))
            XCTAssertTrue(post.isFavoritePost)

        }
        .store(in: &cancellable)
        //when
        userInput.send(.updateFavoriteStatusFor(post: PostViewModelItem(postModel: postModel.first!)))
        waitForExpectations(timeout: 5)
    }
}
