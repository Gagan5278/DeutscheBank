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
    @Published private var posts: [PostViewModelItemProtocol] = []
    // MARK: - init
    init(request: NetworkRequestProtocol, endPoint: ServiceEndPointProtocol, user: LoginUserModel) {
        serviceRequest = request
        loadPostsFromServer(endPoint: endPoint, user: user)
    }
    
    private func loadPostsFromServer(endPoint: ServiceEndPointProtocol, user: LoginUserModel) {
        Task {
            do {
                let postsRecived = try await serviceRequest.callService(
                    with: endPoint,
                    model: [PostModel].self,
                    serviceMethod: .get
                )
                posts = postsRecived.map({
                    PostViewModelItem(postModel: $0)
                })
            } catch let error {
                
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
        case fetchQuoteDidFail
        case fetchQuoteDidSucceed
    }
}
