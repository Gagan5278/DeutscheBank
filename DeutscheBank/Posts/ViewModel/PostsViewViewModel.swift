//
//  PostsViewViewModel.swift
//  DeutscheBank
//
//  Created by Gagan Vishal  on 2023/02/11.
//

import Foundation
import Combine

class PostsViewViewModel {
    private let serviceRequest: NetworkRequestProtocol
    private let output: PassthroughSubject<RequestOutput, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    private let favoritePostService: FavoritePostService
    @Published private var posts: [PostViewModelItemProtocol] = []
    private var recievedRawPostsModel: [PostModel] = []
    private var isFavoriteFilsterEnabled: Bool = false
    private var savedFavoritePostIDS: [Int] = []
    // MARK: - init
    init(
        request: NetworkRequestProtocol,
        user: LoginUserModel,
        codeDataManager: CoreDataManagerProtocol) {
            serviceRequest = request
            favoritePostService = FavoritePostService(user: user, manager: codeDataManager)
            addFavoritePostSubscriber()
            loadPostsFromServerFor(user: user)
        }
    
    func transform(input: AnyPublisher<UserInput, Never>) -> AnyPublisher<RequestOutput, Never> {
        input.sink { [weak self] userEvent in
            switch userEvent {
            case .showFavoriteTypePost(let segment):
                self?.updatePostTableOnFavoiteAndAllSegment(segment)
                self?.output.send(.reloadPost)
            case .updateFavoriteStatusFor(let post):
                self?.updatePostfavoriteStatus(post)
                self?.output.send(.reloadPost)
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    var numberOfRowsInPostTableView: Int {
        posts.count
    }
    
    func getPost(at indexPath: IndexPath) -> PostViewModelItemProtocol {
        posts[indexPath.row]
    }
}

// MARK: - Private Section
extension PostsViewViewModel {
    
    private func updatePostTableOnFavoiteAndAllSegment(_ segment: PostsViewViewModel.PostSegmentControllerEnum) {
        switch segment {
        case .allPosts:
            createPostModelsFromPostRecieved(recievedRawPostsModel)
        case .favoritePosts:
            posts = posts.filter({$0.isFavoritePost})
        }
        self.isFavoriteFilsterEnabled = segment == .favoritePosts
    }
    
    private func updatePostfavoriteStatus(_ post: PostViewModelItemProtocol) {
        self.favoritePostService.updateEntity(for: post)
        if let postIndex = self.posts.firstIndex(where: {$0.postID == post.postID}) {
            let postItem = posts[postIndex]
            posts[postIndex] = post.updatePostStatus(post:
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
        }
    }
    
    private func addFavoritePostSubscriber() {
        favoritePostService.$savedFavoriteEntities
            .sink { [weak self] savedPosts in
                self?.savedFavoritePostIDS =  savedPosts.map { Int($0.postID) }
            }
            .store(in: &cancellables)
    }
    
    private func loadPostsFromServerFor(user: LoginUserModel) {
        Task {
            do {
                let postsRecived = try await serviceRequest.callService(
                    with: ServiceEndPoint.fetchPostsForUser(id: user.userid),
                    model: [PostModel].self,
                    serviceMethod: .get
                )
                if postsRecived.isEmpty {
                    output.send(.fetchPostsDidSucceedWithEmptyList)
                } else {
                    recievedRawPostsModel = postsRecived
                    createPostModelsFromPostRecieved(postsRecived)
                    output.send(.fetchPostsDidSucceed)
                }
            } catch {
                output.send(.fetchPostsDidFail)
            }
        }
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
        case showFavoriteTypePost(segment: PostSegmentControllerEnum)
        case updateFavoriteStatusFor(post: PostViewModelItemProtocol)
    }
    
    enum RequestOutput {
        case fetchPostsDidFail
        case fetchPostsDidSucceed
        case fetchPostsDidSucceedWithEmptyList
        case reloadPost
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
