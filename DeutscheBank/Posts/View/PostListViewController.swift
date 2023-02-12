//
//  PostListViewController.swift
//  DeutscheBank
//
//  Created by Gagan Vishal  on 2023/02/11.
//

import UIKit
import Combine

class PostListViewController: UIViewController {

    private var postsViewModel: PostsViewViewModel!
    var postListCoordinator: Coordinator?
    private lazy var postFilterSegmentController: UISegmentedControl = {
        let sgmntCntl = UISegmentedControl(items: [
            PostSegmentController.allPosts.segmentTitle,
            PostSegmentController.favoritePosts.segmentTitle
          ])
        sgmntCntl.addTarget(
            self,
            action: #selector(segmentedValueChanged(sender:)),
            for: .valueChanged
        )
        sgmntCntl.selectedSegmentIndex = PostSegmentController.allPosts.rawValue
        return sgmntCntl
    }()
    
    private lazy var postTableView: UITableView = {
        let tblView = UITableView()
        tblView.dataSource = self
        tblView.delegate = self
        tblView.estimatedRowHeight = AppConstants.commonPaadingConstants*10
        tblView.rowHeight = UITableView.automaticDimension
        tblView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.postCellIdentifier)
        return tblView
    }()
    
    private let input: PassthroughSubject<PostsViewViewModel.UserInput, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - View Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = AppConstants.PostListScreenConstants.navigationTitle
        setupSubViewsOnMainView()
        bindViewModel()
    }
    
    convenience init(viewModel: PostsViewViewModel) {
        self.init(nibName: nil, bundle: nil)
        postsViewModel = viewModel
    }
    
    private func bindViewModel() {
      let output = postsViewModel.transform(input: input.eraseToAnyPublisher())
      output
        .receive(on: DispatchQueue.main)
        .sink { [weak self] event in
        switch event {
        case .fetchPostsDidSucceed:
            self?.postTableView.reloadData()
        case .fetchPostsDidSucceedWithEmptyList:
            self?.showAlert(
                with: AppConstants.PostListScreenConstants.emptyPostAlertTitle,
                message: AppConstants.PostListScreenConstants.emptyPostAlertMessage
            )
            
        case .fetchPostsDidFail:
            break
        case .toggleFavorite:
            break
        }
      }.store(in: &cancellables)
    }
    
    private func setupSubViewsOnMainView() {
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
            bottom: self.view.safeAreaLayoutGuide.bottomAnchor,
            trailing: self.view.trailingAnchor
        )
    }
    
    // MARK: - Display alert
    private func showAlert(with title: String, message: String) {
        self.showAlertWith(
            title: title,
            message: message,
            firstButtonTitle: AppConstants.PostListScreenConstants.emptyPostButtonTitle,
            withFirstCallback: popToUserIDEntryScreen(action:)
        )
    }
    
    private func popToUserIDEntryScreen(action: UIAlertAction?) {
        postListCoordinator?.popToLastScreen()
    }
    
    // MARK: - Post filter on segment action
    @objc private func segmentedValueChanged(sender: UISegmentedControl) {
        print("Selected Segment Index is : \(sender.selectedSegmentIndex)")
    }
}

extension PostListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

// MARK: - UITableViewDataSource
extension PostListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        postsViewModel.numberOfRowsInPostTableView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let postCell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.postCellIdentifier, for: indexPath) as? PostTableViewCell else {
            return UITableViewCell()
        }
        postCell.item = postsViewModel.getPost(at: indexPath)
        return postCell
    }
}

extension PostListViewController {
    enum PostSegmentController: Int  {
        case allPosts
        case favoritePosts
        
        var segmentTitle: String {
            switch self {
            case .allPosts:
                return AppConstants.PostListScreenConstants.filterAllPostSegmentTitle
            case .favoritePosts:
                return AppConstants.PostListScreenConstants.filterFavoritePostSegmentTitle
            }
        }
    }
}
