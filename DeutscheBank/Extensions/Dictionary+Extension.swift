//
//  Dictionary+Extension.swift
//  DeutscheBank
//
//  Created by Gagan Vishal  on 2023/02/11.
//

import Foundation

extension Dictionary {
    func serialize() throws -> Data {
        try JSONSerialization.data(
            withJSONObject: self,
            options: .prettyPrinted
        )
    }
}
