//
//  CoreDataManager.swift
//  DeutscheBank
//
//  Created by Gagan Vishal  on 2023/02/12.
//

import Foundation
import CoreData

protocol CoreDataManagerProtocol {
    var favoriteEntityName: String { get }
    var viewContext: NSManagedObjectContext { get }
}

class CoreDataManager: CoreDataManagerProtocol {
    private let persistantContainer: NSPersistentContainer
    private let persistantContainerName: String = "DeutscheBank"
    private let entityName: String = "FavoritePostEntity"
    private lazy var context: NSManagedObjectContext = {
        persistantContainer.viewContext
    }()
    
    // MARK: - init
    init() {
        persistantContainer = NSPersistentContainer(name: persistantContainerName)
        persistantContainer.loadPersistentStores { _, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    var favoriteEntityName: String {
        entityName
    }
    
    var viewContext: NSManagedObjectContext {
        context
    }
}
