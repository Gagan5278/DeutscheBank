//
//  CommentTableViewCell.swift
//  DeutscheBank
//
//  Created by Gagan Vishal  on 2023/02/13.
//

import UIKit

class CommentTableViewCell: BaseTableViewCell<CommentsViewViewModelItemProtocol> {

    static let commentCellIdentifier = "commentCellIdentifier"
    
    // MARK: - View Life cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        verticalStackViewConstraintSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override var cellItem: CommentsViewViewModelItemProtocol! {
        didSet {
            setCommenterNameAndCommentBody()
        }
    }
    
    // MARK: - Contraint setup for vertical stack view
    private func verticalStackViewConstraintSetup()  {
        contentView.addSubview(infoView)
        infoView.fillSuperview(padding: UIEdgeInsets(
            top: AppConstants.commonPadingConstants,
            left: AppConstants.commonPadingConstants,
            bottom: AppConstants.commonPadingConstants,
            right: AppConstants.commonPadingConstants)
        )
    }
    
    private func setCommenterNameAndCommentBody() {
        setup(title: cellItem.commenterName, body: cellItem.comment)
    }
}
