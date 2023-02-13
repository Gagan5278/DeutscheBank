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

    override var item: CommentsViewViewModelItemProtocol! {
        didSet {
            setCommenterNameAndCommentBody()
        }
    }
    
    // MARK: - Contraint setup for vertical stack view
    private func verticalStackViewConstraintSetup() -> AnchoredConstraints {
        return verticalStackView.anchor(
            top: contentView.topAnchor,
            leading: contentView.leadingAnchor,
            bottom: contentView.bottomAnchor,
            trailing: contentView.trailingAnchor,
            padding: UIEdgeInsets(
                top: AppConstants.commonPaadingConstants,
                left: AppConstants.commonPaadingConstants,
                bottom: AppConstants.commonPaadingConstants,
                right: AppConstants.commonPaadingConstants)
        )
    }
    
    private func setCommenterNameAndCommentBody() {
        setup(title: item.commenterName, body: item.comment)
    }
    
}
