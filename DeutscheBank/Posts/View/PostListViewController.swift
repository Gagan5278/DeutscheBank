//
//  PostListViewController.swift
//  DeutscheBank
//
//  Created by Gagan Vishal  on 2023/02/11.
//

import UIKit

class PostListViewController: UIViewController {

    private var postsViewModel: PostsViewViewModel!
    
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
        return sgmntCntl
    }()
    
    private lazy var postTableView: UITableView = {
        let tblView = UITableView()
        tblView.dataSource = self
        tblView.estimatedRowHeight = 100
        tblView.rowHeight = UITableView.automaticDimension
        tblView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.postCellIdentifier)
        return tblView
    }()
    
    // MARK: - View Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = AppConstants.PostListScreenConstants.navigationTitle
    }
    
    convenience init(viewModel: PostsViewViewModel) {
        self.init(nibName: nil, bundle: nil)
        postsViewModel = viewModel
    }
    
    private func setupSubViewsOnMainView() {
        self.view.addSubviews(postFilterSegmentController, postTableView)
        postFilterSegmentController.anchor(top: self.view.topAnchor, leading: self.view.leadingAnchor, bottom: nil, trailing: self.view.trailingAnchor)
        postTableView.anchor(top: postFilterSegmentController.bottomAnchor, leading: self.view.leadingAnchor, bottom: self.view.safeAreaLayoutGuide.bottomAnchor, trailing: self.view.trailingAnchor)
        
    }
    // MARK: - Post filter on segment action
    @objc private func segmentedValueChanged(sender: UISegmentedControl) {
        print("Selected Segment Index is : \(sender.selectedSegmentIndex)")
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
    enum PostSegmentController  {
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
