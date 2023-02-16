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
        tblView.isHidden = true
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
    
    private let tableSectionHeaderHeightConstant: CGFloat = AppConstants.commonPadingConstants*5
    private var commentSubscriber: AnyCancellable?
    public private(set) var commentViewModel: CommentsViewViewModel!
    
    // MARK: - View Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = AppConstants.CommentListScreenConstants.navigationTitle
        addVommentsTableViewOnMainViewAndSetupConstraints()
        bindViewModel()
        startActivityIndicatorAnimation()
        startFetchingCommentsFromServer()
    }
    
    convenience init(viewModel: CommentsViewViewModel) {
        self.init(nibName: nil, bundle: nil)
        commentViewModel = viewModel
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let headerView = commentTableView.tableHeaderView as? CommentsTableHeaderView {
            headerView.setHeader(with: commentViewModel)
        }
        commentTableView.sizeHeaderToFit()
    }
    
    private func startFetchingCommentsFromServer() {
        commentViewModel.loadCommentsFromServer()
    }
    
    // MARK: - ViewModel Bidnding/Listner
    private func bindViewModel() {
        commentSubscriber = commentViewModel
            .commentRequestOutput
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] commentOutput in
                switch commentOutput {
                case .fetchCommentsDidSucceed:
                    self?.showAndReloadCommentTableView()
                case .didFailToFetchComments:
                    self?.showAlertOnCommentScreen(
                        with: AppConstants.CommentListScreenConstants.alertTitle,
                        message: AppConstants.CommentListScreenConstants.errorCommentAlertMessage
                    )
                case .fetchCommentssDidSucceedWithEmptyList:
                    self?.showAlertOnCommentScreen(
                        with: AppConstants.CommentListScreenConstants.alertTitle,
                        message: AppConstants.CommentListScreenConstants.emptyPostAlertMessage
                    )
                }
                self?.stopActivityIndicatorAnimation()
            })
    }
    
    private func addVommentsTableViewOnMainViewAndSetupConstraints() {
        self.view.addSubview(commentTableView)
        commentTableView.fillSuperview()
    }
    
    // MARK: - Reload table view on fetch success
    private func showAndReloadCommentTableView() {
        commentTableView.isHidden = false
        commentTableView.reloadData()
    }
    
    // MARK: - Display alert
    private func showAlertOnCommentScreen(with title: String, message: String) {
        self.showAlertWith(
            title: title,
            message: message,
            firstButtonTitle: AppConstants.CommentListScreenConstants.alertButtonTitle
        )
    }
}

// MARK: - UITableViewDelegate
extension CommentsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: CommentsTableSectionHeaderView.commentsTableSectionHeaderViewIdentifier)
            as? CommentsTableSectionHeaderView {
            return header
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        tableSectionHeaderHeightConstant
    }
}

// MARK: - UITableViewDataSource
extension CommentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        commentViewModel.numberOfRowsInCommentTableView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let commentCell = tableView.dequeueReusableCell(
            withIdentifier: CommentTableViewCell.commentCellIdentifier,
            for: indexPath) as? CommentTableViewCell else {
            fatalError("Invalid UITableViewCell found")
        }
        commentCell.cellItem = commentViewModel.getComment(at: indexPath)
        return commentCell
    }
}
