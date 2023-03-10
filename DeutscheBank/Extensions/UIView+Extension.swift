//
//  UIView+Extension.swift
//  DeutscheBank
//
//  Created by Gagan Vishal  on 2023/02/11.
//

import UIKit

extension UIView {
    @discardableResult
    func anchor(
        top: NSLayoutYAxisAnchor?,
        leading: NSLayoutXAxisAnchor?,
        bottom: NSLayoutYAxisAnchor?,
        trailing: NSLayoutXAxisAnchor?,
        padding: UIEdgeInsets = .zero,
        size: CGSize = .zero) -> AnchoredConstraints {
            translatesAutoresizingMaskIntoConstraints = false
            var anchoredConstraints = AnchoredConstraints()
            if let top = top {
                anchoredConstraints.top = topAnchor.constraint(
                    equalTo: top,
                    constant: padding.top
                )
            }
            if let leading = leading {
                anchoredConstraints.leading = leadingAnchor.constraint(
                    equalTo: leading,
                    constant: padding.left
                )
            }
            if let bottom = bottom {
                anchoredConstraints.bottom = bottomAnchor.constraint(
                    equalTo: bottom,
                    constant: -padding.bottom
                )
                anchoredConstraints.bottom!.priority = UILayoutPriority(750)
            }
            if let trailing = trailing {
                anchoredConstraints.trailing = trailingAnchor.constraint(
                    equalTo: trailing,
                    constant: -padding.right
                )
            }
            if size.width != 0 {
                anchoredConstraints.width = widthAnchor.constraint(equalToConstant: size.width)
            }
            if size.height != 0 {
                anchoredConstraints.height = heightAnchor.constraint(equalToConstant: size.height)
            }
            [
                anchoredConstraints.top,
                anchoredConstraints.leading,
                anchoredConstraints.bottom,
                anchoredConstraints.trailing,
                anchoredConstraints.width,
                anchoredConstraints.height
            ].forEach { $0?.isActive = true }
            return anchoredConstraints
        }
    
    func addViewInCenterVertically(with size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superviewCenterYAnchor = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: superviewCenterYAnchor).isActive = true
        }
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    
    func centerInSuperview(size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superviewCenterXAnchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: superviewCenterXAnchor).isActive = true
        }
        if let superviewCenterYAnchor = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: superviewCenterYAnchor).isActive = true
        }
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    
    func fillSuperview(padding: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superviewTopAnchor = superview?.topAnchor {
            topAnchor.constraint(
                equalTo: superviewTopAnchor,
                constant: padding.top
            ).isActive = true
        }
        if let superviewBottomAnchor = superview?.bottomAnchor {
            bottomAnchor.constraint(
                equalTo: superviewBottomAnchor,
                constant: -padding.bottom
            ).isActive = true
        }
        
        if let superviewLeadingAnchor = superview?.leadingAnchor {
            leadingAnchor.constraint(
                equalTo: superviewLeadingAnchor,
                constant: padding.left
            ).isActive = true
        }
        if let superviewTrailingAnchor = superview?.trailingAnchor {
            trailingAnchor.constraint(
                equalTo: superviewTrailingAnchor,
                constant: -padding.right
            ).isActive = true
        }
    }
    
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach(addSubview)
    }
    
    func addBorder(
        borderWidth: CGFloat = 1,
        borderColor: UIColor = UIColor.appPrimaryColor,
        cornerRadius: CGFloat = 10
    ) {
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
    }
}

struct AnchoredConstraints {
    var top, leading, bottom, trailing, width, height: NSLayoutConstraint?
}
