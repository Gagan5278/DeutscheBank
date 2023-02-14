//
//  BaseTableViewCell.swift
//  DeutscheBank
//
//  Created by Gagan Vishal  on 2023/02/11.
//

import UIKit

class BaseTableViewCell<U: Any>: UITableViewCell {
    
    public private(set) lazy var infoView: CommonTitleAndSubTitleInfoView = {
        let view = CommonTitleAndSubTitleInfoView()
        return view
    }()
    
    var cellItem: U!

    // MARK: - View Life cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setup(title: String, body: String) {
        infoView.set(title: title, body: body)
    }
}

