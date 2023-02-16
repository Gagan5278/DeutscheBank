//
//  PostListViewController.swift
//  DeutscheBank
//
//  Created by Gagan Vishal  on 2023/02/11.
//

import UIKit
import Combine

class PostListViewController: BaseViewController {
    public private(set) var postsViewModel: PostsViewViewModel!
    var postListCoordinator: Coordinator?
    private lazy var postFilterSegmentController: UISegmentedControl = {
        let sgmntCntl = UISegmentedControl(items: [
            PostsViewViewModel.PostSegmentControllerEnum.allPosts.segmentTitle,
            PostsViewViewModel.PostSegmentControllerEnum.favoritePosts.segmentTitle
        ])
        sgmntCntl.addTarget(
            self,
            action: #selector(segmentedValueChanged(sender:)),
            for: .valueChanged
        )
        sgmntCntl.selectedSegmentIndex = PostsViewViewModel.PostSegmentControllerEnum.allPosts.rawValue
        return sgmntCntl
    }()
    
    public private(set) lazy var postTableView: UITableView = {
        let tblView = UITableView()
        tblView.dataSource = self
        tblView.delegate = self
        tblView.estimatedRowHeight = AppConstants.commonPadingConstants*10
        tblView.rowHeight = UITableView.automaticDimension
        tblView.register(
            PostTableViewCell.self,
            forCellReuseIdentifier: PostTableViewCell.postCellIdentifier
        )
        return tblView
    }()
    
    private let userInput: PassthroughSubject<PostsViewViewModel.UserInput, Never> = .init()
    private var outputSubscribers = Set<AnyCancellable>()
    
    // MARK: - View Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = AppConstants.PostListScreenConstants.navigationTitle
        addSubViewsOnMainViewAndApplyConstraints()
        bindViewModel()
        startActivityIndicatorAnimation()
        loadPostFromServer()
        displayAlertIfNoInterentAccessibility()
    }
    
    convenience init(viewModel: PostsViewViewModel) {
        self.init(nibName: nil, bundle: nil)
        postsViewModel = viewModel
    }
    
    func loadPostFromServer() {
        userInput.send(.viewLoaded)
    }
}

// MARK: - PostListViewController Private section
extension PostListViewController {
    // MARK: - Bind View Model
    private func bindViewModel() {
        let output = postsViewModel.transform(input: userInput.eraseToAnyPublisher())
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .fetchPostsDidSucceed:
                    self?.reloadPostTableView()
                case .fetchPostsDidSucceedWithEmptyList:
                    self?.showAlert(
                        with: AppConstants.PostListScreenConstants.commonAlertTitle,
                        message: AppConstants.PostListScreenConstants.emptyPostAlertMessage
                    )
                case .fetchPostsDidFail:
                    self?.showAlert(
                        with: AppConstants.PostListScreenConstants.commonAlertTitle,
                        message: AppConstants.PostListScreenConstants.errorPostAlertMessage
                    )
                case .reloadPost:
                    self?.reloadPostTableView()
                case .favoriteLocalPosts:
                    self?.adjustSegmentControllerForOfflineFavoritePostsWhenThereIsNoNetwork()
                    self?.reloadPostTableView()
                }
                self?.stopActivityIndicatorAnimation()
            }.store(in: &outputSubscribers)
    }
    
    private func reloadPostTableView() {
        postTableView.reloadData()
    }
    
    private func adjustSegmentControllerForOfflineFavoritePostsWhenThereIsNoNetwork() {
        postFilterSegmentController.removeSegment(
            at: PostsViewViewModel.PostSegmentControllerEnum.allPosts.rawValue,
            animated: false
        )
    }
    
    private func addSubViewsOnMainViewAndApplyConstraints() {
        self.view.addSubviews(postFilterSegmentController, postTableView)
        postFilterSegmentController.anchor(
            top: self.view.safeAreaLayoutGuide.topAnchor,
            leading: self.view.leadingAnchor,
            bottom: nil,
            trailing: self.view.trailingAnchor
        )
        postTableView.anchor(
            top: postFilterSegmentController.bottomAnchor,
            leading: self.view.leadingAnchor,
            bottom: self.view.bottomAnchor,
            trailing: self.view.trailingAnchor
        )
    }
    
    // MARK: - Display alert when no internet availble and only favorite post will be visible (If saved)
    private func displayAlertIfNoInterentAccessibility() {
        checkForInternetAndShowAlertOnStart(
            with: AppConstants.PostListScreenConstants.offlineModeErrorAlertTitle,
            message: AppConstants.PostListScreenConstants.offlineModeErrorAlertMessageForFavoritePost
        )
    }
    
    // MARK: - Display error alert
    private func showAlert(with title: String, message: String) {
        self.showAlertWith(
            title: title,
            message: message,
            firstButtonTitle: AppConstants.PostListScreenConstants.alertGoBackButtonTitle,
            withFirstCallback: popToUserIDEntryScreen(action:)
        )
    }
    
    private func popToUserIDEntryScreen(action: UIAlertAction?) {
        postListCoordinator?.popToLastScreen()
    }
    
    // MARK: - Post filter segment action event
    @objc
    private func segmentedValueChanged(sender: UISegmentedControl) {
        if let segmentSelected = PostsViewViewModel.PostSegmentControllerEnum(rawValue: sender.selectedSegmentIndex) {
            userInput.send(.showFavoriteTypePost(segment: segmentSelected))
        }
    }
    
    private func onFavoriteIconSelectionFor(_ postCell: PostTableViewCell) {
        postCell.favoriteSelectionCompletionHandler = { [weak self] selectedPost in
            self?.userInput.send(.updateFavoriteStatusFor(post: selectedPost))
        }
    }
    
    private func showAndHideEmptyPostMessageOnTableView() {
        if postsViewModel.numberOfRowsInPostTableView == 0 {
            postTableView.setEmptyView(with: AppConstants.PostListScreenConstants.emptyPostMessage)
        } else {
            postTableView.resetBackgroundViewToNil()
        }
    }
}

// MARK: - UITableViewDelegate
extension PostListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if NetworkReachability.isConnectedToNetwork() {
            postListCoordinator?.pushToShowCommentScreen(for: postsViewModel.getPost(at: indexPath))
        }
    }
}

// MARK: - UITableViewDataSource
extension PostListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        showAndHideEmptyPostMessageOnTableView()
        return postsViewModel.numberOfRowsInPostTableView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let postCell = tableView.dequeueReusableCell(
            withIdentifier: PostTableViewCell.postCellIdentifier,
            for: indexPath) as? PostTableViewCell else {
            fatalError("Invalid PostTableViewCell found")
        }
        postCell.cellItem = postsViewModel.getPost(at: indexPath)
        onFavoriteIconSelectionFor(postCell)
        return postCell
    }
}

