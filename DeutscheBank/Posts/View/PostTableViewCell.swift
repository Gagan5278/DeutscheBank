//
//  PostTableViewCell.swift
//  DeutscheBank
//
//  Created by Gagan Vishal  on 2023/02/11.
//

import UIKit

class PostTableViewCell: BaseTableViewCell<PostViewModelItemProtocol> {
    
    static let postCellIdentifier: String = "postCellIdentifier"
    var favoriteSelectionCompletionHandler: ((PostViewModelItemProtocol) -> Void)?
    
    private let favoriteButtonSize = CGSize(
        width: AppConstants.commonPadingConstants*4,
        height: AppConstants.commonPadingConstants*4
    )
    
    private lazy var favoriteButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "star.fill"), for: .selected)
        btn.setImage(UIImage(systemName: "star"), for: .normal)
        btn.setContentHuggingPriority(UILayoutPriority(1000), for: .horizontal)
        btn.addTarget(
            self,
            action: #selector(didTapFavoriteButton),
            for: .touchUpInside
        )
        return btn
    }()
    
    // MARK: - View Life cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        addViewsOnContentViewAndSetupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
      
    // MARK: - Conetnt View UI Seup
    private func addViewsOnContentViewAndSetupConstraints() {
        contentView.addSubviews(infoView, favoriteButton)
        favoriteButtonConstraintSetup()
        postTitleAndBodyHolderVerticalStackViewConstraintSetup(infoView)
    }
    
    private func favoriteButtonConstraintSetup() {
        favoriteButton.anchor(
            top: nil,
            leading: nil,
            bottom: nil,
            trailing: contentView.trailingAnchor,
            padding: UIEdgeInsets(
                top: 0,
                left: AppConstants.commonPadingConstants,
                bottom: 0,
                right: AppConstants.commonPadingConstants
            ),
            size: favoriteButtonSize
        )
        favoriteButton.addViewInCenterVertically()
    }
    
    private func postTitleAndBodyHolderVerticalStackViewConstraintSetup(_ infoView: UIView) {
        infoView.anchor(
            top: contentView.topAnchor,
            leading: contentView.leadingAnchor,
            bottom: contentView.bottomAnchor,
            trailing: favoriteButton.leadingAnchor,
            padding: UIEdgeInsets(
                top: AppConstants.commonPadingConstants,
                left: AppConstants.commonPadingConstants,
                bottom: AppConstants.commonPadingConstants,
                right: 0
            )
        )
    }
    
    override var cellItem: PostViewModelItemProtocol! {
        didSet {
            setPostTitleAndBody()
        }
    }
    
    private func setPostTitleAndBody() {
        setup(title: cellItem.postTitle, body: cellItem.postBody)
        favoriteButton.isSelected = cellItem.isFavoritePost
    }
    
    // MARK: - Favorite button action
    @objc private func didTapFavoriteButton(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        favoriteSelectionCompletionHandler?(cellItem)
    }
}
