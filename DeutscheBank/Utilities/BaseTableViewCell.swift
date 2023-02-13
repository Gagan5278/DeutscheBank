//
//  BaseTableViewCell.swift
//  DeutscheBank
//
//  Created by Gagan Vishal  on 2023/02/11.
//

import UIKit

class BaseTableViewCell<U: Any>: UITableViewCell {
    
    var item: U!
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
    
    public private(set) var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = AppConstants.commonPaadingConstants
        stackView.distribution =  .fill
        return stackView
    }()
    // MARK: - View Life cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addTitleAndBodyLabelInVerticalStacView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func addTitleAndBodyLabelInVerticalStacView() {
        verticalStackView.addArrangedSubview(titleLabel)
        verticalStackView.addArrangedSubview(bodyLabel)
    }
    
    func setup(title: String, body: String) {
        titleLabel.text = title
        bodyLabel.text = body
    }
}

