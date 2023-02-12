//
//  PostTableViewCell.swift
//  DeutscheBank
//
//  Created by Gagan Vishal  on 2023/02/11.
//

import UIKit

class PostTableViewCell: BaseTableViewCell<PostViewModelItemProtocol> {
    
    static let postCellIdentifier: String = "postCellIdentifier"
    
    private let favoriteButtonSize = CGSize(
        width: AppConstants.commonPaadingConstants*3,
        height: AppConstants.commonPaadingConstants*3
    )
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .titleFont
        lbl.textColor = .appPrimaryColor
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViewsOnContentView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func addViewsOnContentView() {
        contentView.addSubviews(titleLabel, favoriteButton)
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
        
        titleLabel.anchor(
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
            titleLabel.text = item.postTitle
        }
    }
    
    @objc private func didTapFavoriteButton(sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
}
