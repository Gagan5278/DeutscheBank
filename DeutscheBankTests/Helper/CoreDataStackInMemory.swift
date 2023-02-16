//
//  CoreDataStackInMemory.swift
//  DeutscheBankTests
//
//  Created by Gagan Vishal  on 2023/02/12.
//

import Foundation
import CoreData
@testable import DeutscheBank

class CoreDataStackInMemory: CoreDataManagerProtocol  {
    var favoriteEntityName: String {
        "FavoritePostEntity"
    }
    
    var viewContext: NSManagedObjectContext {
        context
    }
    
    private let persistantContainer: NSPersistentContainer
    // MARK: - init
    init() {
        persistantContainer = {
            let container = NSPersistentContainer(name: "DeutscheBank")
            let persistentDecsription = NSPersistentStoreDescription()
            // Set memory type
            persistentDecsription.type = NSInMemoryStoreType
            // Set description to NSPersistentContainer
            container.persistentStoreDescriptions = [persistentDecsription]
            container.loadPersistentStores {(_, error) in
                if let error = error {
                    fatalError("Something went wrong \(error.localizedDescription)")
                }
            }
            return container
        }()
    }
    
    private lazy var context: NSManagedObjectContext = {
        return persistantContainer.viewContext
    }()
}

