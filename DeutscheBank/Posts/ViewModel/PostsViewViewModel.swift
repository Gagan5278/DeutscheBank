//
//  PostsViewViewModel.swift
//  DeutscheBank
//
//  Created by Gagan Vishal  on 2023/02/11.
//

import Foundation
import Combine
class PostsViewViewModel {
    
    public private(set) var serviceRequest: NetworkRequestProtocol
    private let output: PassthroughSubject<RequestOutput, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    private let favoritePostService: FavoritePostService
    private var posts: [PostViewModelItemProtocol] = []
    private var savedFavoritePostIDS: [Int] = []
    // MARK: - init
    init(request: NetworkRequestProtocol, user: LoginUserModel) {
        serviceRequest = request
        favoritePostService = FavoritePostService(user: user)
        addFavoritePostSubscriber()
        loadPostsFromServerFor(user: user)
    }
    
    func transform(input: AnyPublisher<UserInput, Never>) -> AnyPublisher<RequestOutput, Never> {
        input.sink { [weak self] userEvent in
            switch userEvent {
            case .showFavoriteTypePost(let isFavorite):
                break
            case .updateFavoriteStatusFor(let post):
                self?.favoritePostService.updateEntity(for: post)
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
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
                    if savedFavoritePostIDS.isEmpty {
                        posts = postsRecived.map({
                            PostViewModelItem(postModel: $0)
                        })
                    } else {
                        posts = postsRecived.map({
                            PostViewModelItem(postModel: $0, isFavorite: savedFavoritePostIDS.contains($0.id))
                        })
                    }
                    output.send(.fetchPostsDidSucceed)
                }
            } catch let _ {
                output.send(.fetchPostsDidFail)
            }
        }
    }
    
    var numberOfRowsInPostTableView: Int {
        posts.count
    }
    
    func getPost(at indexPath: IndexPath) -> PostViewModelItemProtocol {
        posts[indexPath.row]
    }
}

extension PostsViewViewModel {
    enum UserInput {
        case showFavoriteTypePost(isFavorite: Bool)
        case updateFavoriteStatusFor(post: PostViewModelItemProtocol)
    }
    
    enum RequestOutput {
        case fetchPostsDidFail
        case fetchPostsDidSucceed
        case fetchPostsDidSucceedWithEmptyList
        case toggleFavorite
    }
}
