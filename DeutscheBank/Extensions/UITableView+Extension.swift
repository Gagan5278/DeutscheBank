//
//  UITableView+Extension.swift
//  DeutscheBank
//
//  Created by Gagan Vishal  on 2023/02/14.
//

import UIKit

extension UITableView {
    func sizeHeaderToFit() {
        if let headerView = self.tableHeaderView {
            headerView.setNeedsLayout()
            headerView.layoutIfNeeded()
            let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            var frame = headerView.frame
            frame.size.height = height
            headerView.frame = frame
            self.tableHeaderView = headerView
        }
    }
}
