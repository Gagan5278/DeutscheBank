//
//  Array+Extension.swift
//  DeutscheBank
//
//  Created by Gagan Vishal  on 2023/02/12.
//

import Foundation

extension Array where Element: Equatable{
    mutating func remove (element: Element) {
        if let i = self.firstIndex(of: element) {
            self.remove(at: i)
        }
    }
}
