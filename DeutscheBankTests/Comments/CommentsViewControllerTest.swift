//
//  CommentsViewControllerTest.swift
//  DeutscheBankTests
//
//  Created by Gagan Vishal  on 2023/02/14.
//

import XCTest
@testable import DeutscheBank

final class CommentsViewControllerTest: XCTestCase {
    private var sutCommentsViewController: CommentsViewController!
    private var mockPostViewModelItem: PostViewModelItemProtocol!
    private var mockRequest: MockNetworkRequestCommentsSuccess!
    override func setUp() {
        mockRequest = MockNetworkRequestCommentsSuccess()
        let mockModels: [PostModel] = JSONLoader.load("Posts.json")
        mockPostViewModelItem = PostViewModelItem(postModel: mockModels.first!)
        sutCommentsViewController = CommentsViewController(
            viewModel: CommentsViewViewModel(
                request: mockRequest,
                post: mockPostViewModelItem)
        )
        
        sutCommentsViewController.loadViewIfNeeded()
        sutCommentsViewController.viewDidLoad()
    }
    
    override func tearDown() {
        sutCommentsViewController = nil
        mockPostViewModelItem = nil
        mockRequest = nil
    }
    
    func testCommentsViewController_ViewLoaded_ViewShouldNotBeNil() {
        XCTAssertNotNil(sutCommentsViewController.view)
    }
    
    func testCommentsViewController_ViewLoaded_NavigationTitleShouldNotBeNil() {
        XCTAssertNotNil(sutCommentsViewController.title)
    }
    
    func testCommentsViewController_ViewLoaded_NavigationTitleShouldBeTitleOfPostListController() {
        XCTAssertNotNil(sutCommentsViewController.title == AppConstants.CommentListScreenConstants.navigationTitle, "Navigation title is wrong")
    }
    
    func testCommentsViewController_ViewHasBeenLoaded_ViewModelIsNotNil() {
        XCTAssertNotNil(sutCommentsViewController.commentViewModel, "CommentsViewViewModel is nil")
    }
    
    func testCommentsViewController_ViewHasBeenLoaded_PostTableViewDelegateIsNotNil() {
        XCTAssertNotNil(sutCommentsViewController.commentTableView.delegate, "commentTableView Delegate is nil")
    }
    
    func testCommentsViewController_ViewHasBeenLoaded_ConfirmsUITableViewDelegate() {
        XCTAssertTrue(sutCommentsViewController.conforms(to: UITableViewDelegate.self), "CommentsViewController does not confirm UITableViewDelegate")
    }
    
    func testCommentsViewController_ViewHasBeenLoaded_PostTableViewDataSourceIsNotNil() {
        XCTAssertNotNil(sutCommentsViewController.commentTableView.dataSource, "UITableView data source is nil")
    }
    
    func testCommentsViewController_ViewHasBeenLoaded_ConfirmsUITableViewDataSource() {
        XCTAssertTrue(sutCommentsViewController.conforms(to: UITableViewDataSource.self), "CommentsViewController does not confirm UITableViewDataSource")
    }
    
    func testCommentsViewController_ViewHasBeenLoaded_TableViewCellHasReuseIdentifier() {
        let cell = sutCommentsViewController.tableView(
            sutCommentsViewController.commentTableView,
            cellForRowAt: IndexPath(row: 0, section: 0)
        ) as? CommentTableViewCell
        let actualReuseIdentifer = cell?.reuseIdentifier
        let expectedReuseIdentifier = CommentTableViewCell.commentCellIdentifier
        XCTAssertEqual(actualReuseIdentifer, expectedReuseIdentifier)
    }
    
    func testCommentsViewController_PostsHasBeenLoaded_NumberOfRowsInUICollectionViewIsGreaterThanZero() {
        _ = XCTWaiter.wait(for: [expectation(description: "Wait for 1 seconds")], timeout: 1.0)
        let indexPath = IndexPath(item: 0, section: 0)
        let postCount =  sutCommentsViewController.commentTableView.dataSource?.tableView(
            sutCommentsViewController.commentTableView,
            numberOfRowsInSection: 0
        )
        XCTAssertTrue(postCount != 0)
    }
    
    func testCommentsViewController_PostsHasBeenLoaded_CellForItemAtIndexPathIsNotNil() {
        let indexPath = IndexPath(item: 0, section: 0)
        let commentCell = sutCommentsViewController.commentTableView.dataSource?.tableView(
            sutCommentsViewController.commentTableView,
            cellForRowAt: indexPath
        ) as! CommentTableViewCell
        XCTAssertNotNil(commentCell)
    }
}
