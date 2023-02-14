//
//  SaveFavoriteCoreDataTest.swift
//  DeutscheBankTests
//
//  Created by Gagan Vishal  on 2023/02/12.
//

import XCTest
@testable import DeutscheBank

final class InMemoryCoreDataSaveFavoriteTest: XCTestCase {
    private var coreDataStackInMemory: CoreDataStackInMemory!
    
    override func setUp() {
        coreDataStackInMemory = CoreDataStackInMemory()
    }

    override func tearDown() {
        coreDataStackInMemory = nil
    }

    
    func testCoreDataStackInMemory_SaveAnObject() {
        XCTAssertNotNil(coreDataStackInMemory.viewContext)
    }
    
    func testSerahcAndCreateObjectIfNotExistWithIdentifier() {
     
    }
    
    func testinsertNewObjectInContext()
    {
 
    }
    
    
    //MARK:- Test Model equality
    func testSavedModelEqaulity() {

    }
    
}
