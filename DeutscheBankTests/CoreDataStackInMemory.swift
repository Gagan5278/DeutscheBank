//
//  CoreDataStackInMemory.swift
//  DeutscheBankTests
//
//  Created by Gagan Vishal  on 2023/02/12.
//

import Foundation
import CoreData
class CoreDataStackInMemory {
   static let sharedInstance = CoreDataStackInMemory()
   
   //PersistentContainer
   lazy var persistentConatiner: NSPersistentContainer = {
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
   
   //MARK:- Managed object Context
   lazy var managedObjectContext: NSManagedObjectContext = {
       return persistentConatiner.viewContext
   }()
}

