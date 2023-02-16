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
    private var coreDataManager: CoreDataManagerProtocol!
    private var sutPostViewModel: PostsViewViewModel!
    private var request: MockNetworkRequestPostSuccess!
    
    override func setUp() {
        coreDataManager = CoreDataStackInMemory()
        request = MockNetworkRequestPostSuccess()
        sutPostViewModel = PostsViewViewModel(
            request: request,
            user: mockUser, codeDataManager: coreDataManager
    )
    }
    
    override func tearDown() {
        sutPostViewModel = nil
        request = nil
        coreDataManager = nil
        cancellable = []
    }
    
    func testPostsViewViewModel_WhenPostModelLoaded_OutputShouldBeFetchPostsDidSucceed() async throws {
        let expectation = expectation(description: "OutputShouldBeFetchPostsDidSucceed")
        let task = sutPostViewModel.fetchPostsTaskForLoggedIn(user: mockUser)
        let posts = try await task.value
        XCTAssertNotNil(posts)
        XCTAssertTrue(posts!.count > 0)
        sutPostViewModel
            .requestOutput
            .sink { output in
                XCTAssertTrue(output == .fetchPostsDidSucceed)
                expectation.fulfill()
            }
            .store(in: &cancellable)
        try await sutPostViewModel.readPostsFromRecieved(task: task)
        wait(for: [expectation], timeout: 5)
    }
    
    func testPostsViewViewModel_WhenPostModelLoadingFailed_ShouldReturnFetchPostsDidSucceedWithEmptyList() async throws {
        let expectation = expectation(description: "ShouldReturnFetchPostsDidSucceedWithEmptyList")
        sutPostViewModel = nil
       let mocksutPostViewModel =  PostsViewViewModel(
            request: MockNetworkRequestPostSuccessWithEmptyModel(),
            user: LoginUserModel(userid: 1),
            codeDataManager: CoreDataStackInMemory()
        )
        
        let task = mocksutPostViewModel.fetchPostsTaskForLoggedIn(user: mockUser)
        let posts = try await task.value
        XCTAssertNotNil(posts)
        XCTAssertTrue(posts!.isEmpty)
        mocksutPostViewModel
            .requestOutput
            .sink { output in
                XCTAssertTrue(output == .fetchPostsDidSucceedWithEmptyList)
                expectation.fulfill()
                      }
            .store(in: &cancellable)
        try await mocksutPostViewModel.readPostsFromRecieved(task: task)
        wait(for: [expectation], timeout: 5)
    }
    
    func testPostsViewViewModel_WhenPostModelLoadingFailed_ShouldReturnFetchPostsDidFail() async throws {
        //Given
        let expectation = expectation(description: "ShouldReturnFetchPostsDidFail")
        sutPostViewModel = nil
        // Given
        sutPostViewModel =  PostsViewViewModel(
            request: MockNetworkRequestPostFailure(),
            user: mockUser,
            codeDataManager: coreDataManager
        )
        let task = sutPostViewModel.fetchPostsTaskForLoggedIn(user: mockUser)
        let posts = try await task.value
        //Then
        XCTAssertNil(posts)
        sutPostViewModel.requestOutput
            .sink { output in
                XCTAssertTrue(output == .fetchPostsDidFail)
                expectation.fulfill()
            }
            .store(in: &cancellable)
        // When
        try await sutPostViewModel.readPostsFromRecieved(task: task)
        wait(for: [expectation], timeout: 5)
    }
    
    func testPostsViewViewModel_WhenPostModelLoaded_GetPostAtGivenIndexPathMustHaveEqualPostID() async throws {
        //Given
        let expectation = expectation(description: "GetPostAtGivenIndexPathMustHaveEqualPostID")
        let postModels: [PostModel] = JSONLoader.load("Posts.json")
        let task = sutPostViewModel.fetchPostsTaskForLoggedIn(user: mockUser)
        // Then
        let posts = try await task.value
        XCTAssertNotNil(posts)
        sutPostViewModel.requestOutput
            .sink { [weak self] output in
                guard let self = self else { return }
                let post = self.sutPostViewModel.getPost(at: IndexPath(row: 0, section: 0))
                XCTAssertTrue(post.postID == postModels[0].id)
                expectation.fulfill()
            }
            .store(in: &cancellable)
        // When
        try await sutPostViewModel.readPostsFromRecieved(task: task)
        wait(for: [expectation], timeout: 5)
    }
    
    func testPostsViewViewModel_WhenPostModelLoadedUpdatePostStatusToFavorite_ShouldHaveFavoriteTrue() async throws {
        let expectation = expectation(description: "ShouldHaveFavoriteTrue")
        // Given
        let userInput: PassthroughSubject<PostsViewViewModel.UserInput, Never> = .init()
        let postViewModel = sutPostViewModel!
        let postModel: [PostModel]  = JSONLoader.load("Posts.json")
        let _ = postViewModel.transform(input: userInput.eraseToAnyPublisher())
        let task = sutPostViewModel.fetchPostsTaskForLoggedIn(user: mockUser)
        let posts = try await task.value
        XCTAssertNotNil(posts)
        // Then
        postViewModel.requestOutput
            .dropFirst()
            .sink { req in
                print(req)
                XCTAssertTrue(req == .reloadPosts)
                let post = postViewModel.getPost(at: IndexPath(row: 0, section: 0))
                XCTAssertTrue(post.isFavoritePost)
                expectation.fulfill()
            }
            .store(in: &cancellable)
        // When
        try await sutPostViewModel.readPostsFromRecieved(task: task)
        userInput.send(.updateFavoriteStatusFor(post: PostViewModelItem(postModel: postModel.first!)))
        wait(for: [expectation], timeout: 5)
    }
    
    func testPostsViewViewModel_WhenPostModelLoadedUpdatePostStatusToFavorite_FavoritePostsHasZeroRows() async throws {
        let expectation = expectation(description: "FavoritePostsHasZeroRows")
        let userInput: PassthroughSubject<PostsViewViewModel.UserInput, Never> = .init()
        // Given
        let _ = sutPostViewModel.transform(input: userInput.eraseToAnyPublisher())
        // Then
        let task = sutPostViewModel.fetchPostsTaskForLoggedIn(user: mockUser)
        let posts = try await task.value
        XCTAssertNotNil(posts)

        sutPostViewModel
            .requestOutput
            .dropFirst()
            .sink { [weak self] output in
                XCTAssertTrue(output == .reloadPosts)
                XCTAssertTrue(self?.sutPostViewModel.numberOfRowsInPostTableView == 0)
                expectation.fulfill()
            }
            .store(in: &cancellable)
        //when
        try await sutPostViewModel.readPostsFromRecieved(task: task)
        userInput.send(.showFavoriteTypePost(segment: .favoritePosts))
        wait(for: [expectation], timeout: 5)
    }
}
