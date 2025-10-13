//
//  URLRequest+Extension.swift
//
//  Created by banie setijoso
//

import Foundation

extension URLRequest {
    var curlString: String {
        var components = ["curl -i"]

        if let method = self.httpMethod {
            components.append("-X \(method)")
        }

        if let headers = self.allHTTPHeaderFields {
            for (header, value) in headers {
                components.append("-H \"\(header): \(value)\"")
            }
        }

        if let httpBodyData = self.httpBody, let httpBodyString = String(data: httpBodyData, encoding: .utf8) {
            components.append("-d \"\(httpBodyString.replacingOccurrences(of: "\"", with: "\\\""))\"")
        }

        if let url = self.url {
            components.append("\"\(url.absoluteString)\"")
        }

        return components.joined(separator: " ")
    }

    mutating func decorate(using headers: [String: String]) {
        for header in headers {
            setValue(header.value, forHTTPHeaderField: header.key)
        }
    }
}
