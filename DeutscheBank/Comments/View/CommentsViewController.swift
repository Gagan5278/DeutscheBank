//
//  CommentsViewController.swift
//  DeutscheBank
//
//  Created by Gagan Vishal  on 2023/02/13.
//

import UIKit
import Combine

class CommentsViewController: BaseViewController {
    
    public private(set) lazy var commentTableView: UITableView = {
        let tblView = UITableView()
        tblView.dataSource = self
        tblView.delegate = self
        tblView.estimatedRowHeight = AppConstants.commonPadingConstants*10
        tblView.rowHeight = UITableView.automaticDimension
        let tableHeaderView = CommentsTableHeaderView(frame: .zero)
        tableHeaderView.translatesAutoresizingMaskIntoConstraints = false
        tblView.tableHeaderView = tableHeaderView
        tableHeaderView.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        tblView.register(
            CommentTableViewCell.self,
            forCellReuseIdentifier: CommentTableViewCell.commentCellIdentifier
        )
        tblView.register(
            CommentsTableSectionHeaderView.self,
            forHeaderFooterViewReuseIdentifier: CommentsTableSectionHeaderView.commentsTableSectionHeaderViewIdentifier
        )
        return tblView
    }()
    
    private var commentSubscriber: AnyCancellable?
    private let tableSectionHeight: CGFloat = AppConstants.commonPadingConstants*5
    public private(set) var commentViewModel: CommentsViewViewModel!
    
    // MARK: - View Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = AppConstants.CommentListScreenConstants.navigationTitle
        commentsTableViewSetup()
        bindViewModel()
    }
    
    convenience init(viewModel: CommentsViewViewModel) {
        self.init(nibName: nil, bundle: nil)
        commentViewModel = viewModel
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let headerView = commentTableView.tableHeaderView as? CommentsTableHeaderView {
            headerView.setHeader(title: commentViewModel.selectedPostTitle, message: commentViewModel.selectedPostBody, isFavoritePost: commentViewModel.isFavoritePost)
        }
        commentTableView.sizeHeaderToFit()
    }
    
    // MARK: - ViewModel Bidnding/Listner
    private func bindViewModel() {
        commentSubscriber = commentViewModel
            .commentOutput
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] commentOutput in
                switch commentOutput {
                case .fetchCommentsDidSucceed:
                    self?.commentTableView.reloadData()
                case .didFailToFetchComments:
                    self?.showAlertOnComment(
                        with: AppConstants.CommentListScreenConstants.alertTitle,
                        message: AppConstants.CommentListScreenConstants.errorCommentAlertMessage
                    )
                case .fetchCommentssDidSucceedWithEmptyList:
                    self?.showAlertOnComment(
                        with: AppConstants.CommentListScreenConstants.alertTitle,
                        message: AppConstants.CommentListScreenConstants.emptyPostAlertMessage
                    )
                }
                self?.stopActivityIndicatorAnimation()
            })
    }
    
    private func commentsTableViewSetup() {
        self.view.addSubview(commentTableView)
        commentTableView.fillSuperview()
    }
    
    // MARK: - Display alert
    private func showAlertOnComment(with title: String, message: String) {
        self.showAlertWith(
            title: title,
            message: message,
            firstButtonTitle: AppConstants.PostListScreenConstants.alertGoBackButtonTitle
        )
    }
}

// MARK: - UITableViewDelegate
extension CommentsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CommentsTableSectionHeaderView.commentsTableSectionHeaderViewIdentifier) as? CommentsTableSectionHeaderView {
            return header
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        tableSectionHeight
    }
}

// MARK: - UITableViewDataSource
extension CommentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        commentViewModel.numberOfRowsInCommentTableView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let commentCell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.commentCellIdentifier, for: indexPath) as? CommentTableViewCell else {
            return UITableViewCell()
        }
        commentCell.cellItem = commentViewModel.getPostComment(at: indexPath)
        return commentCell
    }
}
