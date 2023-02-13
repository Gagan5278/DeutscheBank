//
//  CommentsViewController.swift
//  DeutscheBank
//
//  Created by Gagan Vishal  on 2023/02/13.
//

import UIKit

class CommentsViewController: BaseViewController {

    private var commentViewModel: CommentsViewViewModel!
    // MARK: - View Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = AppConstants.CommentListScreenConstants.navigationTitle
    }
    
    convenience init(viewModel: CommentsViewViewModel) {
        self.init(nibName: nil, bundle: nil)
        commentViewModel = viewModel
    }
}
