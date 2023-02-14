//
//  BaseTableViewCell.swift
//  DeutscheBank
//
//  Created by Gagan Vishal  on 2023/02/11.
//

import UIKit

class BaseTableViewCell<U: Any>: UITableViewCell {
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .titleFont
        lbl.textColor = .appPrimaryColor
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private let bodyLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .subTitleFont
        lbl.textColor = .appSecondaryColor
        lbl.numberOfLines = 0
        return lbl
    }()
    
    public private(set) lazy var verticalStackView: VerticalStackView = {
        let stackView = VerticalStackView(views: titleLabel, bodyLabel)
        return stackView
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
        titleLabel.text = title
        bodyLabel.text = body
    }
}

