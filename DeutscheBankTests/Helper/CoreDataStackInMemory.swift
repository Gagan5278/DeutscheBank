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
            //Create NSPersistentStoreDescription
            let persistentDecsription = NSPersistentStoreDescription()
            //set memory type
            persistentDecsription.type = NSInMemoryStoreType
            //set description to NSPersistentContainer
            container.persistentStoreDescriptions = [persistentDecsription]
            //load container
            container.loadPersistentStores { (description, error) in
                if let _ = error {
                    fatalError("Something went wrong")
                }
            }
            return container
        }()
    }

   
   private lazy var context: NSManagedObjectContext = {
       return persistantContainer.viewContext
   }()
}

