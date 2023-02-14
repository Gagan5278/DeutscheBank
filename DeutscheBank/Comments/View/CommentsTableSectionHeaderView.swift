//
//  CommentsTableSectionHeaderView.swift
//  DeutscheBank
//
//  Created by Gagan Vishal  on 2023/02/14.
//

import UIKit

class CommentsTableSectionHeaderView: UITableViewHeaderFooterView {

    static let commentsTableSectionHeaderViewIdentifier = "CommentsTableSectionHeaderViewdentifier"
    
    let headerTitleLable: UILabel = {
        let lbl = UILabel()
        lbl.font = .headerFont
        lbl.textColor = .appPrimaryColor
        lbl.text = AppConstants.CommentListScreenConstants.commentSetionHeaderTitle
        lbl.backgroundColor = .systemGray5
        lbl.textAlignment = .center
        return lbl
    }()
        
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addHeaderTitleOnContentViewAndSetupConstraint()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func addHeaderTitleOnContentViewAndSetupConstraint() {
        contentView.addSubview(headerTitleLable)
        headerTitleLable.fillSuperview()
    }
}
