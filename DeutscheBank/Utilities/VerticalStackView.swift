//
//  BaseViewController.swift
//  DeutscheBank
//
//  Created by Gagan Vishal  on 2023/02/14.
//

import UIKit

class VerticalStackView: UIStackView {

    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .vertical
        spacing = AppConstants.commonPadingConstants
        distribution =  .fill
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(frame: CGRect = .zero, views: UIView...) {
        self.init(frame: frame)
        views.forEach { subView in
            addArrangedSubview(subView)
        }
    }
}
