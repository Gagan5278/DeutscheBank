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
    private var sutPostViewModel: PostsViewViewModel!
    
    override func setUp() {
        sutPostViewModel = PostsViewViewModel(
            request: MockNetworkRequestPostSuccess(),
            user: mockUser, codeDataManager: coreDataManager
        )
    }
    
    override func tearDown() {
        sutPostViewModel = nil
        cancellable = []
    }
    
    func testPostsViewViewModel_WhenPostModelLoaded_NumberOfRowsSouldBeMoreThanZero()  {
        sutPostViewModel.requestOutput
            .sink { [weak self] output in
                XCTAssertTrue(output == .fetchPostsDidSucceed)
                XCTAssertTrue((self?.sutPostViewModel.numberOfRowsInPostTableView)! > 0)
            }
            .store(in: &cancellable)
    }
    
    func testPostsViewViewModel_WhenPostModelLoadingFailed_ShouldReturnFetchPostsDidFail() {
        //Given
        sutPostViewModel = nil
        sutPostViewModel =  PostsViewViewModel(
            request: MockNetworkRequestPostFailure(),
            user: mockUser,
            codeDataManager: coreDataManager
        )
        // When
        sutPostViewModel.requestOutput
            .receive(on: RunLoop.main)
            .sink { output in
                // Then
                XCTAssertTrue(output == .fetchPostsDidFail)
            }
            .store(in: &cancellable)
    }
    
    func testPostsViewViewModel_WhenPostModelLoadingFailed_ShouldReturnFetchPostsDidSucceedWithEmptyList() {
        //Given
        sutPostViewModel = nil
        sutPostViewModel =  PostsViewViewModel(
            request: MockNetworkRequestPostSuccessWithEmptyModel(),
            user: mockUser,
            codeDataManager: coreDataManager
        )
        // When
        sutPostViewModel.requestOutput
            .receive(on: RunLoop.main)
            .sink { output in
                // Then
                XCTAssertTrue(output == .fetchPostsDidSucceedWithEmptyList)
            }
            .store(in: &cancellable)
    }
    
    func testPostsViewViewModel_WhenPostModelLoaded_GetPostAtGivenIndexPathMustHaveEqualPostID() {
        sutPostViewModel.requestOutput
            .sink {  output in
                let post = self.sutPostViewModel.getPost(at: IndexPath(row: 0, section: 0))
            let postModel: [PostModel] = JSONLoader.load("Posts.json")
                XCTAssertTrue(post.postID == postModel[0].id)
        }
        .store(in: &cancellable)
    }
    
    func testPostsViewViewModel_WhenPostModelLoadedUpdatePostStatusToFavorite_ShouldHaveFavoriteTrue() {
       // Given
        let userInput: PassthroughSubject<PostsViewViewModel.UserInput, Never> = .init()
        let postViewModel = sutPostViewModel!
        let postModel: [PostModel]  = JSONLoader.load("Posts.json")
        let _ = postViewModel.transform(input: userInput.eraseToAnyPublisher())
        // Then
        postViewModel.requestOutput
            .sink { req in
            XCTAssertTrue(req == .reloadPost)
            let post = postViewModel.getPost(at: IndexPath(row: 0, section: 0))
            XCTAssertTrue(post.isFavoritePost)
        }
        .store(in: &cancellable)
        //when
        userInput.send(.updateFavoriteStatusFor(post: PostViewModelItem(postModel: postModel.first!)))
    }
    
    func testPostsViewViewModel_WhenPostModelLoadedUpdatePostStatusToFavorite_favoritePosts() {
        let userInput: CurrentValueSubject<PostsViewViewModel.UserInput, Never> = .init(.showFavoriteTypePost(segment: .favoritePosts))
       // Given
        let _ = sutPostViewModel.transform(input: userInput.eraseToAnyPublisher())
        // Then
        sutPostViewModel.requestOutput
            .sink { [weak self] req in
            XCTAssertTrue(req == .reloadPost)
            XCTAssertTrue(self?.sutPostViewModel.numberOfRowsInPostTableView == 0)
//            expectation.fulfill()
        }
        .store(in: &cancellable)
        //when
        userInput.send(.showFavoriteTypePost(segment: .favoritePosts))
    }
}
