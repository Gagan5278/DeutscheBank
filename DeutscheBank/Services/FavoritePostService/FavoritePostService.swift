//
//  FavoritePostService.swift
//  DeutscheBank
//
//  Created by Gagan Vishal  on 2023/02/12.
//

import Foundation
import CoreData
import Combine

class FavoritePostService {
    @Published var savedFavoriteEntities: [FavoritePostEntity] = []
    private let coreDataManager: CoreDataManager
    
    // MARK: init
    init(user: LoginUserModel) {
        coreDataManager = CoreDataManager()
        fetchFavoritePostFor(user: user)
    }
}

// MARK: - Public Section
extension FavoritePostService {
    func updateEntity(for model: PostViewModelItemProtocol) {
        if let savedEntity = savedFavoriteEntities.first(where: { $0.postID == model.postID }) {
            delete(entity: savedEntity)
        } else {
            add(model: model)
        }
    }
}

// MARK: - Private Section
extension FavoritePostService {
    private func fetchFavoritePostFor(user: LoginUserModel) {
        let fetchRequest = NSFetchRequest<FavoritePostEntity>(entityName: coreDataManager.favoriteEntityName)
        //fetchRequest.predicate = NSPredicate(format: "userID = %d", user.userid)
        do {
            savedFavoriteEntities = try coreDataManager.context.fetch(fetchRequest)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - add into Favorite Entity
    private func add(model: PostViewModelItemProtocol) {
        let entity = FavoritePostEntity(context: coreDataManager.context)
        entity.postID = Int16(model.postID)
        entity.userID = Int16(model.userID)
        entity.postTitle = model.postTitle
        entity.postBody = model.postBody
        saveEntity(comletionHandler: {isSuccess in
            savedFavoriteEntities.append(entity)
        })
    }
    
    // MARK: - Delete
    private func delete(entity: FavoritePostEntity) {
        coreDataManager.context.delete(entity)
        saveEntity(comletionHandler: {isSuccess in
            savedFavoriteEntities.remove(element: entity)
        })
    }
    
    // MARK: - Save entity
    private func saveEntity(comletionHandler: (Bool) -> Void) {
        do {
            try coreDataManager.context.save()
            comletionHandler(true)
        } catch let error {
            print("error : \(error.localizedDescription)")
            comletionHandler(false)
        }
    }
}
