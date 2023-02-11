//
//  URLRequest+Extension.swift
//  DeutscheBank
//
//  Created by Gagan Vishal  on 2023/02/11.
//

import Foundation

extension URLRequest {
    mutating func addHeader(from headers: [String: String]?) {
        guard let headers = headers, !headers.isEmpty else {
            return
        }
        
        for header in headers {
            self.addValue(
                header.value,
                forHTTPHeaderField: header.key
            )
        }
    }
}
