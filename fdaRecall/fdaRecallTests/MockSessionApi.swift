//
//  MockSessionApi.swift
//  fdaRecall
//
//  Created by banie setijoso on 2025-10-13.
//

import Foundation
@testable import fdaRecall

final class MockSessionApi: SessionApi {
    
    var mockResult: (Data, URLResponse)?
    var shouldThrowError = false
    var mockError: Error?
    
    var dataCalled = false
    var lastRequest: URLRequest?
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        dataCalled = true
        lastRequest = request
        
        if shouldThrowError {
            throw mockError ?? URLError(.unknown)
        }
        
        if let result = mockResult {
            return result
        } else {
            throw URLError(.badServerResponse)
        }
    }
}
