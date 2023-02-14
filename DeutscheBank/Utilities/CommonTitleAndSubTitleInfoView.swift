//
//  CommonTitleAndSubTitleInfoView.swift
//  DeutscheBank
//
//  Created by Gagan Vishal  on 2023/02/14.
//

import UIKit

class CommonTitleAndSubTitleInfoView: UIView {

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
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        verticalStackViewSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func verticalStackViewSetup() {
        addSubview(verticalStackView)
        verticalStackView.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor)
    }
    
    func set(title: String, body: String) {
        titleLabel.text = title
        bodyLabel.text = body
    }
}
