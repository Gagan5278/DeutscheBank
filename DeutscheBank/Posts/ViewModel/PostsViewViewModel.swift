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
    
    private var posts: [PostViewModelItemProtocol] = []
    // MARK: - init
    init(request: NetworkRequestProtocol, user: LoginUserModel) {
        serviceRequest = request
        loadPostsFromServerFor(user: user)
    }
    
    func transform(input: AnyPublisher<UserInput, Never>) -> AnyPublisher<RequestOutput, Never> {
        input.sink { [weak self] userEvent in
            switch userEvent {
            case .showFavoriteTypePost(let isFavorite):
                break
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    private func loadPostsFromServerFor(user: LoginUserModel) {
        Task {
            do {
                let postsRecived = try await serviceRequest.callService(
                    with: ServiceEndPoint.fetchPostsForUser(id: user.userid),
                    model: [PostModel].self,
                    serviceMethod: .get
                )
                posts = postsRecived.map({
                    PostViewModelItem(postModel: $0)
                })
                
                if posts.isEmpty {
                    output.send(.fetchPostsDidSucceedWithEmptyList)
                } else {
                    output.send(.fetchPostsDidSucceed)
                }
            } catch let error {
                print(error)
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
    }
    
    enum RequestOutput {
        case fetchPostsDidFail
        case fetchPostsDidSucceed
        case fetchPostsDidSucceedWithEmptyList
        case toggleFavorite
    }
}
