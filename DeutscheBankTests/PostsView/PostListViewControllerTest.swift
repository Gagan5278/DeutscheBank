//
//  PostListViewControllerTest.swift
//  DeutscheBankTests
//
//  Created by Gagan Vishal  on 2023/02/12.
//

import XCTest
@testable import DeutscheBank

final class PostListViewControllerTest: XCTestCase {
    private var sutPostListViewController: PostListViewController!
    private var request: MockNetworkRequestPostSuccess!
    private let mockUser = LoginUserModel(userid: 1)
    private var coreDataManager: CoreDataManagerProtocol!
    private var mockNavigationController: UINavigationControllerMock!
    
    override func setUp() {
        coreDataManager = CoreDataStackInMemory()
        request = MockNetworkRequestPostSuccess()
        sutPostListViewController = PostListViewController(viewModel: PostsViewViewModel(
            request: request,
            user: mockUser,
            codeDataManager: coreDataManager)
        )
        mockNavigationController = UINavigationControllerMock(rootViewController: sutPostListViewController)
        sutPostListViewController.loadViewIfNeeded()
        sutPostListViewController.viewDidLoad()
    }
    
    override func tearDown() {
        coreDataManager = nil
        request = nil
        sutPostListViewController = nil
    }
    
    func testPostListViewController_ViewLoaded_ViewShouldNotBeNil() {
        XCTAssertNotNil(sutPostListViewController.view)
    }
    
    func testPostListViewController_ViewLoaded_NavigationTitleShouldNotBeNil() {
        XCTAssertNotNil(sutPostListViewController.title)
    }
    
    func testPostListViewController_ViewLoaded_NavigationTitleShouldBeTitleOfPostListController() {
        XCTAssertNotNil(sutPostListViewController.title == AppConstants.PostListScreenConstants.navigationTitle, "Navigation title is wrong")
    }
    
    func testPostListViewController_ViewHasBeenLoaded_ViewModelIsNotNil() {
        XCTAssertNotNil(sutPostListViewController.postsViewModel, "PostsViewViewModel is nil")
    }
    
    func testPostListViewController_ViewHasBeenLoaded_PostTableViewDelegateIsNotNil() {
        XCTAssertNotNil(sutPostListViewController.postTableView.delegate, "PostTableView Delegate is nil")
    }
    
    func testPostListViewController_ViewHasBeenLoaded_ConfirmsUITableViewDelegate() {
        XCTAssertTrue(sutPostListViewController.conforms(to: UITableViewDelegate.self), "Does not confirm UITableViewDelegate")
    }
    
    func testPostListViewController_ViewHasBeenLoaded_PostTableViewDataSourceIsNotNil() {
        XCTAssertNotNil(sutPostListViewController.postTableView.dataSource, "UITableView data source is nil")
    }
    
    func testPostListViewController_ViewHasBeenLoaded_ConfirmsUITableViewDataSource() {
        XCTAssertTrue(sutPostListViewController.conforms(to: UITableViewDataSource.self), "Does not confirm UITableViewDataSource")
    }
    
    func testPostListViewController_ViewHasBeenLoaded_TableViewCellHasReuseIdentifier() {
        sutPostListViewController.startLoadingPostFromServerForLoggedInUser()
        let cell = sutPostListViewController.tableView(
            sutPostListViewController.postTableView,
            cellForRowAt: IndexPath(row: 0, section: 0)
        ) as? PostTableViewCell
        let actualReuseIdentifer = cell?.reuseIdentifier
        let expectedReuseIdentifier = PostTableViewCell.postCellIdentifier
        XCTAssertEqual(actualReuseIdentifer, expectedReuseIdentifier)
    }
    
    func testPostListViewController_PostsHasBeenLoaded_NumberOfRowsInUICollectionViewIsGreaterThanZero() {
        sutPostListViewController.startLoadingPostFromServerForLoggedInUser()
        
        let postCount =  sutPostListViewController.postTableView.dataSource?.tableView(
            sutPostListViewController.postTableView,
            numberOfRowsInSection: 0)
        XCTAssertTrue(postCount != 0)
    }
    
    func testPostListViewController_PostsHasBeenLoaded_CellForItemAtIndexPathOfUITableViewViewCell() {
        sutPostListViewController.startLoadingPostFromServerForLoggedInUser()
        _ = XCTWaiter.wait(for: [expectation(description: "Wait for 2 seconds")], timeout: 2.0)
        let indexPath = IndexPath(item: 0, section: 0)
        let cell = sutPostListViewController.postTableView.dataSource?.tableView(
            sutPostListViewController.postTableView,
            cellForRowAt: indexPath
        ) as! PostTableViewCell
        XCTAssertEqual(sutPostListViewController.postsViewModel.getPost(at: indexPath).postID, cell.cellItem.postID)
    }
    
    func testPostListViewController_PostsHasBeenLoadedDidSelectRowAtOfUITableViewViewCell_NavigateToCommentScreen() {
        sutPostListViewController.tableView(
            sutPostListViewController.postTableView,
            didSelectRowAt: IndexPath(row: 0, section: 0)
        )
        XCTAssertTrue(mockNavigationController.pushViewControllerCalled)
    }
}
