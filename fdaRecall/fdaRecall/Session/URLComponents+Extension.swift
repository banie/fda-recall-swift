//
//  URLComponents+Extension.swift
//
//  Created by banie setijoso
//

import Foundation

extension URLComponents {
    mutating func append(parameters: [String: Any]) {
        var newQueryItems: [URLQueryItem] = []
        for parameter in parameters {
            let value = parameter.value
            if let valueString = value as? String {
                newQueryItems.append(URLQueryItem(name: parameter.key, value: valueString))
            } else if let valueInt = value as? Int {
                newQueryItems.append(URLQueryItem(name: parameter.key, value: String(valueInt)))
            } else if let valueStrings = value as? [String] {
                for valueString in valueStrings {
                    newQueryItems.append(URLQueryItem(name: parameter.key, value: valueString))
                }
            } else if let valueInts = value as? [Int] {
                for valueInt in valueInts {
                    newQueryItems.append(URLQueryItem(name: parameter.key, value: String(valueInt)))
                }
            }
        }

        var currentQueryItems = queryItems ?? []
        currentQueryItems.append(contentsOf: newQueryItems)
        queryItems = currentQueryItems
    }
}
