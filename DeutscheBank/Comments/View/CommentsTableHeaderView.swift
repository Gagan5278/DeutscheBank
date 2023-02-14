//
//  CommentsTableHeaderView.swift
//  DeutscheBank
//
//  Created by Gagan Vishal  on 2023/02/14.
//

import UIKit

class CommentsTableHeaderView: UIView {
    
    private let infoView = CommonTitleAndSubTitleInfoView()
    
    private let favoriteIcon: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(systemName: "star.fill")
        imgView.contentMode = .scaleAspectFit
        imgView.widthAnchor.constraint(equalToConstant: AppConstants.commonPadingConstants*3).isActive = true
        return imgView
    }()

    private lazy var horizontalStack: UIStackView = {
        let stkView = UIStackView(arrangedSubviews: [infoView, favoriteIcon])
        return stkView
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addOnMainView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func addOnMainView() {
        addSubview(horizontalStack)
        horizontalStack.fillSuperview(
            padding: UIEdgeInsets(
                top: AppConstants.commonPadingConstants,
                left: AppConstants.commonPadingConstants,
                bottom: 0,
                right: AppConstants.commonPadingConstants)
        )
    }
        
    func setHeader(title: String, message: String, isFavoritePost: Bool = false) {
        infoView.set(title: title, body: message)
        if isFavoritePost {
            favoriteIcon.isHidden = false
        } else {
            favoriteIcon.isHidden = true
        }
    }
}
