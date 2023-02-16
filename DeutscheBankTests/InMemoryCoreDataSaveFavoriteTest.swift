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
    private var loggedinUser: LoginUserModel!
    private var sutFavoritePostService: FavoritePostService!
    private let postModels: [PostModel] = JSONLoader.load("Posts.json")

    override func setUp() {
        loggedinUser = LoginUserModel(userid: 101)
        coreDataStackInMemory = CoreDataStackInMemory()
        sutFavoritePostService = FavoritePostService(
            user: loggedinUser,
            manager: coreDataStackInMemory
        )
    }
    
    override func tearDown() {
        loggedinUser = nil
        coreDataStackInMemory = nil
        sutFavoritePostService = nil
    }
    
    func testCoreDataStackInMemory_ViewContextIsNotNil() {
        XCTAssertNotNil(coreDataStackInMemory.viewContext)
    }
    
    func testCoreDataStackInMemory_SaveAnObjectInCoreData_ObjectMustReturnSameWithCountOne() {
        // Given
        sutFavoritePostService.updateEntity(for: PostViewModelItem(postModel: postModels.first!))
        // When
        let savedObjet = sutFavoritePostService.savedFavoriteEntities
        // Then
        XCTAssertTrue(savedObjet.count == 1)
        XCTAssertTrue(savedObjet.first!.postID == postModels.first!.id)
    }
    
    func testCoreDataStackInMemory_DeleteAnObjectInCoreData_ReturnedArrayMustBeEmpty() {
        // Given
        sutFavoritePostService.updateEntity(for: PostViewModelItem(postModel: postModels.first!))
        // When
        sutFavoritePostService.updateEntity(for: PostViewModelItem(postModel: postModels.first!))
        // Then
        let savedObjet = sutFavoritePostService.savedFavoriteEntities
        XCTAssertTrue(savedObjet.count == 0)
    }
}
