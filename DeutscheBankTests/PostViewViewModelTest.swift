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

    private var postViewModel: PostsViewViewModel!
    private var cancellable = Set<AnyCancellable>()
    private let userInput: PassthroughSubject<PostsViewViewModel.UserInput, Never> = .init()
    private let mockUser = LoginUserModel(userid: 1)
    private let coreDataManager = CoreDataStackInMemory()
    
    override func setUp() {
        setupPostViewViewModel()
    }

    override func tearDown() {
        postViewModel = nil
    }

    private func setupPostViewViewModel() {
        postViewModel =  PostsViewViewModel(
            request: MockNetworkRequestSuccessTest(),
            user: mockUser, codeDataManager: coreDataManager
        )
    }
    
    func testPostsViewViewModel_WhenPostModelLoaded_NumberOfRowsSouldBeMoreThanZero() {
        let outputRequest =  postViewModel.transform(input: userInput.eraseToAnyPublisher())
        outputRequest.sink { [weak self] output in
            guard let self = self else {return}
            XCTAssertTrue(output == .fetchPostsDidSucceed)
            XCTAssertTrue(self.postViewModel.numberOfRowsInPostTableView > 0)
        }
        .store(in: &cancellable)
    }
    
    func testPostsViewViewModel_WhenPostModelLoadingFailed_ShouldReturnFetchPostsDidFail() {
        //Given
        postViewModel = nil
        postViewModel =  PostsViewViewModel(
            request: MockNetworkRequestFailureTest(),
            user: mockUser,
            codeDataManager: coreDataManager
        )
        // When
        let outputRequest =  postViewModel.transform(input: userInput.eraseToAnyPublisher())
        outputRequest.sink { output in
            // Then
            XCTAssertTrue(output == .fetchPostsDidFail)
        }
        .store(in: &cancellable)
    }
    
    func testPostsViewViewModel_WhenPostModelLoadingFailed_ShouldReturnFetchPostsDidSucceedWithEmptyList() {
        //Given
        postViewModel = nil
        postViewModel =  PostsViewViewModel(
            request: MockNetworkRequestSuccessWithEmptyModelTest(),
            user: mockUser,
            codeDataManager: coreDataManager
        )
        // When
        let outputRequest =  postViewModel.transform(input: userInput.eraseToAnyPublisher())
        outputRequest.sink { output in
            // Then
            XCTAssertTrue(output == .fetchPostsDidSucceedWithEmptyList)
        }
        .store(in: &cancellable)
    }
    
    func testPostsViewViewModel_WhenPostModelLoaded_GetPostAtGivenIndexPathMustHaveEqualPostID() {
        //Given
        let postModel: [PostModel]  = JSONLoader.load("Posts.json")
        let outputRequest =  postViewModel.transform(input: userInput.eraseToAnyPublisher())
        // When
        outputRequest.sink { [weak self] output in
            guard let self = self else {return}
            //Then
            XCTAssertTrue(output == .fetchPostsDidSucceed)
            let post = self.postViewModel.getPost(at: IndexPath(row: 0, section: 0))
            XCTAssertTrue(post.postID == postModel[0].id)
        }
        .store(in: &cancellable)

    }
        
    func testPostsViewViewModel_WhenPostModelLoadedUpdatePostStatusToFavorite_ShouldHaveFavoriteTrye() {
        //Given
        let postModel: [PostModel]  = JSONLoader.load("Posts.json")
        // When
        userInput.send(.updateFavoriteStatusFor(post: PostViewModelItem(postModel: postModel.first!)))
        let outputRequest =  postViewModel.transform(input: userInput.eraseToAnyPublisher())
        outputRequest.sink { [weak self] output in
            guard let self = self else {return}
            // Then
            XCTAssertTrue(output == .reloadPost)
            let post = self.postViewModel.getPost(at: IndexPath(row: 0, section: 0))
            XCTAssertTrue(post.isFavoritePost)
        }
        .store(in: &cancellable)
    }
}
