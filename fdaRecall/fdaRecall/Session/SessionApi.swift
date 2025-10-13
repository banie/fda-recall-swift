//
//  SessionApi.swift
//
//  Created by banie setijoso
//

import Foundation

protocol SessionApi {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

class DataSession: SessionApi {
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        try await URLSession.shared.data(for: request)
    }
}
