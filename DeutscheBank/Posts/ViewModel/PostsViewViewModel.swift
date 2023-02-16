//
//  PostsViewViewModel.swift
//  DeutscheBank
//
//  Created by Gagan Vishal  on 2023/02/11.
//

import Foundation
import Combine

class PostsViewViewModel {
    public private(set) var requestOutput: PassthroughSubject<RequestOutput, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    private var posts: [PostViewModelItemProtocol] = []
    private var recievedRawPostsModel: [PostModel] = []
    private var savedFavoritePostIDS: [Int] = []
    private var isFavoriteFilsterEnabled: Bool = false
    private let loginUserModel: LoginUserModel!
    private let serviceRequest: NetworkRequestProtocol
    public private(set) var favoritePostService: FavoritePostService
    // MARK: - init
    init(
        request: NetworkRequestProtocol,
        user: LoginUserModel,
        codeDataManager: CoreDataManagerProtocol) {
            serviceRequest = request
            loginUserModel = user
            favoritePostService = FavoritePostService(user: user, manager: codeDataManager)
            addFavoritePostSubscriber()
        }
    
    func transform(input: AnyPublisher<UserInput, Never>) -> AnyPublisher<RequestOutput, Never> {
        input.sink { [weak self] userEvent in
            guard let self = self else { return }
            switch userEvent {
            case .viewLoaded:
                if NetworkReachability.isConnectedToNetwork() {
                    self.fetchUserPostsFromServer()
                }
            case .showFavoriteTypePost(let segment):
                self.updatePostTableOnFavoiteAndAllSegment(segment)
            case .updateFavoriteStatusFor(let post):
                self.updatePostfavoriteStatus(post)
            }
        }.store(in: &cancellables)
        return requestOutput.eraseToAnyPublisher()
    }
    
    var numberOfRowsInPostTableView: Int {
        posts.count
    }
    
    func getPost(at indexPath: IndexPath) -> PostViewModelItemProtocol {
        posts[indexPath.row]
    }
    
    func fetchPostsTaskForLoggedIn(user: LoginUserModel) -> Task<[PostModel]?, Error> {
        return Task {
            try? await serviceRequest.callService(
                with: ServiceEndPoint.fetchPostsForUser(id: user.userid),
                model: [PostModel].self,
                serviceMethod: .get)
        }
    }
    
    func readPostsFromRecieved(task: Task<[PostModel]?, Error>) async throws  {
        if let postsRecived = try? await task.value {
            if postsRecived.isEmpty {
                requestOutput.send(.fetchPostsDidSucceedWithEmptyList)
            } else {
                recievedRawPostsModel = postsRecived
                createPostModelsFromPostRecieved(postsRecived)
                requestOutput.send(.fetchPostsDidSucceed)
            }
        } else {
            requestOutput.send(.fetchPostsDidFail)
        }
    }
}

// MARK: - Private Section
extension PostsViewViewModel {
    private func fetchUserPostsFromServer() {
         Task {
             let task = fetchPostsTaskForLoggedIn(user: self.loginUserModel)
             try await readPostsFromRecieved(task: task)
         }
     }
    
    private func updatePostTableOnFavoiteAndAllSegment(_ segment: PostsViewViewModel.PostSegmentControllerEnum) {
        switch segment {
        case .allPosts:
            createPostModelsFromPostRecieved(recievedRawPostsModel)
        case .favoritePosts:
            posts = posts.filter({$0.isFavoritePost})
        }
        self.isFavoriteFilsterEnabled = segment == .favoritePosts
        requestOutput.send(.reloadPosts)
    }
    
    private func updatePostfavoriteStatus(_ post: PostViewModelItemProtocol) {
        self.favoritePostService.updateEntity(for: post)
        if let postIndex = self.posts.firstIndex(where: {$0.postID == post.postID}) {
            let postItem = posts[postIndex]
            posts[postIndex] = post.updatePostStatusFor(post:
                                                        PostModel(
                                                            userId: postItem.userID,
                                                            id: postItem.postID,
                                                            title: postItem.postTitle,
                                                            body: postItem.postBody),
                                                     isFavorite: !postItem.isFavoritePost
            )
            if isFavoriteFilsterEnabled {
                posts = posts.filter ({ $0.isFavoritePost })
            }
            self.requestOutput.send(.reloadPosts)
        }
    }
    
    private func addFavoritePostSubscriber() {
        favoritePostService.$savedFavoriteEntities
            .receive(on: DispatchQueue.main)
            .sink { [weak self] savedPosts in
                if NetworkReachability.isConnectedToNetwork(){
                    self?.savedFavoritePostIDS =  savedPosts.map { Int($0.postID) }
                } else {
                    self?.posts = savedPosts.map({
                        PostViewModelItem(
                            postModel: PostModel(
                                userId: Int($0.userID),
                                id: Int($0.postID),
                                title: $0.postTitle ?? "",
                                body: $0.postBody ?? ""
                            ),
                            isFavorite: true)
                    })
                    self?.requestOutput.send(.favoriteLocalPosts)
                }
            }
            .store(in: &cancellables)
    }
    
    private func createPostModelsFromPostRecieved(_ postsRecived: [PostModel]) {
        if savedFavoritePostIDS.isEmpty {
            posts = postsRecived.map({
                PostViewModelItem(postModel: $0)
            })
        } else {
            posts = postsRecived.map({
                PostViewModelItem(
                    postModel: $0,
                    isFavorite: savedFavoritePostIDS.contains($0.id)
                )
            })
        }
    }
}

// MARK: - User Input and Request Output
extension PostsViewViewModel {
    enum UserInput {
        case viewLoaded
        case showFavoriteTypePost(segment: PostSegmentControllerEnum)
        case updateFavoriteStatusFor(post: PostViewModelItemProtocol)
    }
    
    enum RequestOutput {
        case fetchPostsDidFail
        case fetchPostsDidSucceed
        case fetchPostsDidSucceedWithEmptyList
        case reloadPosts
        case favoriteLocalPosts
    }
    
    enum PostSegmentControllerEnum: Int  {
        case allPosts
        case favoritePosts
        
        var segmentTitle: String {
            switch self {
            case .allPosts:
                return AppConstants.PostListScreenConstants.filterAllPostSegmentTitle
            case .favoritePosts:
                return AppConstants.PostListScreenConstants.filterFavoritePostSegmentTitle
            }
        }
    }
}
