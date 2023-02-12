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
        width: AppConstants.commonPaadingConstants*4,
        height: AppConstants.commonPaadingConstants*4
    )
    
    private let postTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .titleFont
        lbl.textColor = .appPrimaryColor
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private let postBodyLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .subTitleFont
        lbl.textColor = .appSecondaryColor
        lbl.numberOfLines = 0
        return lbl
    }()
    
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
        let stackView = createVerticalStackHolderForPostTitleAndBody()
        contentView.addSubviews(stackView, favoriteButton)
        favoriteButtonConstraintSetup()
        postTitleAndBodyHolderVerticalStackViewConstraintSetup(stackView)
    }
    
    private func createVerticalStackHolderForPostTitleAndBody() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [postTitleLabel, postBodyLabel])
        stackView.axis = .vertical
        stackView.spacing = AppConstants.commonPaadingConstants
        stackView.distribution =  .fill
        return stackView
    }
    
    private func favoriteButtonConstraintSetup() {
        favoriteButton.anchor(
            top: nil,
            leading: nil,
            bottom: nil,
            trailing: contentView.trailingAnchor,
            padding: UIEdgeInsets(
                top: 0,
                left: AppConstants.commonPaadingConstants,
                bottom: 0,
                right: AppConstants.commonPaadingConstants
            ),
            size: favoriteButtonSize
        )
        favoriteButton.addViewInCenterVertically()
    }
    
    private func postTitleAndBodyHolderVerticalStackViewConstraintSetup(_ stackView: UIStackView) {
         stackView.anchor(
            top: contentView.topAnchor,
            leading: contentView.leadingAnchor,
            bottom: contentView.bottomAnchor,
            trailing: favoriteButton.leadingAnchor,
            padding: UIEdgeInsets(
                top: AppConstants.commonPaadingConstants,
                left: AppConstants.commonPaadingConstants,
                bottom: AppConstants.commonPaadingConstants,
                right: 0
            )
        )
    }
    
    override var item: PostViewModelItemProtocol! {
        didSet {
            setPostTitleAndBody()
        }
    }
    
    private func setPostTitleAndBody() {
        postTitleLabel.text = item.postTitle
        postBodyLabel.text = item.postBody
        favoriteButton.isSelected = item.isFavoritePost
    }
    
    
    // MARK: - Favorite button action
    @objc private func didTapFavoriteButton(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        favoriteSelectionCompletionHandler?(item)
    }
}
