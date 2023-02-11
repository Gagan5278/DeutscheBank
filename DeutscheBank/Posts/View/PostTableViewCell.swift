//
//  PostTableViewCell.swift
//  DeutscheBank
//
//  Created by Gagan Vishal  on 2023/02/11.
//

import UIKit

class PostTableViewCell: BaseTableViewCell<PostModel> {

    static let postCellIdentifier: String = "postCellIdentifier"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override var item: PostModel! {
        didSet {
            
        }
    }
    
}
