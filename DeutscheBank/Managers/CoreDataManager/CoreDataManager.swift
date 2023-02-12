//
//  CoreDataManager.swift
//  DeutscheBank
//
//  Created by Gagan Vishal  on 2023/02/12.
//

import Foundation
import CoreData

class CoreDataManager {
    private let persistantContainer: NSPersistentContainer
    private let persistantContainerName: String = "DeutscheBank"
    private let entityName: String = "FavoritePostEntity"
    public private(set) lazy var context: NSManagedObjectContext = {
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
}
