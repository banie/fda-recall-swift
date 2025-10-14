//
//  HttpSessionTests.swift
//  fdaRecallTests
//
//  Created by banie setijoso on 2025-10-13.
//

import XCTest
@preconcurrency import Foundation
@testable import fdaRecall

@MainActor final class HttpSessionTests: XCTestCase {
    
    var sut: HttpSession!
    var mockSessionApi: MockSessionApi!
    
    override func setUp() {
        super.setUp()
        mockSessionApi = MockSessionApi()
    }
    
    override func tearDown() {
        sut = nil
        mockSessionApi = nil
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testInitializationSuccess() {
        // Given
        let apiKey = "test-api-key"
        let urlPath = "https://api.fda.gov/food/enforcement.json"
        
        // When
        sut = HttpSession(apiKey: apiKey, fullUrlPath: urlPath, sessionApi: mockSessionApi)
        
        // Then
        XCTAssertNotNil(sut)
    }
    
    func testInitializationFailure_WithEmptyURL() {
        // Given
        let apiKey = "test-api-key"
        let emptyUrlPath = ""
        
        // When
        sut = HttpSession(apiKey: apiKey, fullUrlPath: emptyUrlPath, sessionApi: mockSessionApi)
        
        // Then
        XCTAssertNil(sut)
    }
    
    // MARK: - GET Request Tests
    
    func testGetSuccess() async {
        // Given
        sut = HttpSession(apiKey: "test-key", fullUrlPath: "https://api.fda.gov/food/enforcement.json", sessionApi: mockSessionApi)
        XCTAssertNotNil(sut)
        
        let mockResponse = FDARecallResponse(
            meta: Meta(
                disclaimer: "Test disclaimer",
                terms: "Test terms",
                license: "Test license",
                lastUpdated: "2024-01-01",
                results: MetaResults(skip: 0, limit: 10, total: 1)
            ),
            results: []
        )
        
        let mockData = try! JSONEncoder().encode(mockResponse)
        let mockURLResponse = HTTPURLResponse(
            url: URL(string: "https://api.fda.gov/food/enforcement.json")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        
        mockSessionApi.mockResult = (mockData, mockURLResponse)
        
        // When
        let result: Result<FDARecallResponse, DataError> = await sut.get(parameters: ["skip": 0, "limit": 10])
        
        // Then
        switch result {
        case .success(let response):
            XCTAssertEqual(response.meta.disclaimer, "Test disclaimer")
            XCTAssertEqual(response.results.count, 0)
        case .failure(let error):
            XCTFail("Expected success but got failure: \(error)")
        }
        
        // Verify request was made
        XCTAssertTrue(mockSessionApi.dataCalled)
        XCTAssertNotNil(mockSessionApi.lastRequest)
        XCTAssertEqual(mockSessionApi.lastRequest?.httpMethod, "GET")
    }
    
    func testGetWithParameters() async {
        // Given
        sut = HttpSession(apiKey: "test-key", fullUrlPath: "https://api.fda.gov/food/enforcement.json", sessionApi: mockSessionApi)
        XCTAssertNotNil(sut)
        
        let mockResponse = FDARecallResponse(
            meta: Meta(disclaimer: "", terms: "", license: "", lastUpdated: "", results: MetaResults(skip: 0, limit: 0, total: 0)),
            results: []
        )
        
        let mockData = try! JSONEncoder().encode(mockResponse)
        let mockURLResponse = HTTPURLResponse(
            url: URL(string: "https://api.fda.gov/food/enforcement.json")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        
        mockSessionApi.mockResult = (mockData, mockURLResponse)
        
        // When
        let parameters: [String : Any] = ["skip": 20, "limit": 10, "sort": "recall_initiation_date:desc"]
        let result: Result<FDARecallResponse, DataError> = await sut.get(parameters: parameters)
        
        // Then
        switch result {
        case .success(_):
            XCTAssertTrue(mockSessionApi.dataCalled)
            if let request = mockSessionApi.lastRequest,
               let url = request.url,
               let components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
                let queryItems = components.queryItems ?? []
                let queryDict = Dictionary(uniqueKeysWithValues: queryItems.map { ($0.name, $0.value ?? "") })
                XCTAssertEqual(queryDict["skip"], "20")
                XCTAssertEqual(queryDict["limit"], "10")
                XCTAssertEqual(queryDict["sort"], "recall_initiation_date:desc")
            } else {
                XCTFail("Could not parse request URL")
            }
        case .failure(let error):
            XCTFail("Expected success but got failure: \(error)")
        }
    }
    
    func testGetWithHeaders() async {
        // Given
        sut = HttpSession(apiKey: "test-key", fullUrlPath: "https://api.fda.gov/food/enforcement.json", sessionApi: mockSessionApi)
        XCTAssertNotNil(sut)
        
        let mockResponse = FDARecallResponse(
            meta: Meta(disclaimer: "", terms: "", license: "", lastUpdated: "", results: MetaResults(skip: 0, limit: 0, total: 0)),
            results: []
        )
        
        let mockData = try! JSONEncoder().encode(mockResponse)
        let mockURLResponse = HTTPURLResponse(
            url: URL(string: "https://api.fda.gov/food/enforcement.json")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        
        mockSessionApi.mockResult = (mockData, mockURLResponse)
        
        // When
        let customHeaders = ["Custom-Header": "Custom-Value"]
        let result: Result<FDARecallResponse, DataError> = await sut.get(headers: customHeaders)
        
        // Then
        switch result {
        case .success(_):
            XCTAssertTrue(mockSessionApi.dataCalled)
            if let request = mockSessionApi.lastRequest {
                XCTAssertEqual(request.value(forHTTPHeaderField: "Custom-Header"), "Custom-Value")
                XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "application/json")
                XCTAssertEqual(request.value(forHTTPHeaderField: "x-api-key"), "test-key")
            } else {
                XCTFail("Request was nil")
            }
        case .failure(let error):
            XCTFail("Expected success but got failure: \(error)")
        }
    }
    
    // MARK: - Error Handling Tests
    
    func testGetWithSessionError() async {
        // Given
        sut = HttpSession(apiKey: "test-key", fullUrlPath: "https://api.fda.gov/food/enforcement.json", sessionApi: mockSessionApi)
        XCTAssertNotNil(sut)
        
        mockSessionApi.shouldThrowError = true
        mockSessionApi.mockError = URLError(.notConnectedToInternet)
        
        // When
        let result: Result<FDARecallResponse, DataError> = await sut.get()
        
        // Then
        switch result {
        case .success(_):
            XCTFail("Expected failure but got success")
        case .failure(let error):
            if case .sessionError(let message) = error {
                XCTAssertTrue(message.contains("The operation couldn’t be completed"))
            } else {
                XCTFail("Expected sessionError but got: \(error)")
            }
        }
    }
    
    func testGetWithHTTPError() async {
        // Given
        sut = HttpSession(apiKey: "test-key", fullUrlPath: "https://api.fda.gov/food/enforcement.json", sessionApi: mockSessionApi)
        XCTAssertNotNil(sut)
        
        let mockData = Data()
        let mockURLResponse = HTTPURLResponse(
            url: URL(string: "https://api.fda.gov/food/enforcement.json")!,
            statusCode: 404,
            httpVersion: nil,
            headerFields: nil
        )!
        
        mockSessionApi.mockResult = (mockData, mockURLResponse)
        
        // When
        let result: Result<FDARecallResponse, DataError> = await sut.get()
        
        // Then
        switch result {
        case .success(_):
            XCTFail("Expected failure but got success")
        case .failure(let error):
            if case .httpError(let status, let message) = error {
                XCTAssertEqual(status, HTTPStatusCode.notFound)
                XCTAssertTrue(message.contains("404"))
            } else {
                XCTFail("Expected httpError but got: \(error)")
            }
        }
    }
    
    func testGetWithParsingError() async {
        // Given
        sut = HttpSession(apiKey: "test-key", fullUrlPath: "https://api.fda.gov/food/enforcement.json", sessionApi: mockSessionApi)
        XCTAssertNotNil(sut)
        
        let invalidJSONData = "invalid json".data(using: .utf8)!
        let mockURLResponse = HTTPURLResponse(
            url: URL(string: "https://api.fda.gov/food/enforcement.json")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        
        mockSessionApi.mockResult = (invalidJSONData, mockURLResponse)
        
        // When
        let result: Result<FDARecallResponse, DataError> = await sut.get()
        
        // Then
        switch result {
        case .success(_):
            XCTFail("Expected failure but got success")
        case .failure(let error):
            if case .parsingError(_, let data) = error {
                XCTAssertEqual(data, "invalid json")
            } else {
                XCTFail("Expected parsingError but got: \(error)")
            }
        }
    }
    
    // MARK: - Default Headers Tests
    
    func testDefaultHeaders() {
        // Given
        sut = HttpSession(apiKey: "test-api-key", fullUrlPath: "https://api.fda.gov/food/enforcement.json", sessionApi: mockSessionApi)
        XCTAssertNotNil(sut)
        
        // When
        let headers = sut.makeDefaultHeaders()
        
        // Then
        XCTAssertEqual(headers["Content-Type"], "application/json")
        XCTAssertEqual(headers["Accept"], "*/*")
        XCTAssertEqual(headers["Accept-Encoding"], "gzip, deflate, br")
        XCTAssertEqual(headers["Connection"], "keep-alive")
        XCTAssertEqual(headers["x-api-key"], "test-api-key")
    }
    
    // MARK: - Other HTTP Methods Tests
    
    func testPostMethod() async {
        // Given
        sut = HttpSession(apiKey: "test-key", fullUrlPath: "https://api.fda.gov/food/enforcement.json", sessionApi: mockSessionApi)
        XCTAssertNotNil(sut)
        
        let mockResponse = FDARecallResponse(
            meta: Meta(disclaimer: "", terms: "", license: "", lastUpdated: "", results: MetaResults(skip: 0, limit: 0, total: 0)),
            results: []
        )
        
        let mockData = try! JSONEncoder().encode(mockResponse)
        let mockURLResponse = HTTPURLResponse(
            url: URL(string: "https://api.fda.gov/food/enforcement.json")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        
        mockSessionApi.mockResult = (mockData, mockURLResponse)
        
        // When
        let result: Result<FDARecallResponse, DataError> = await sut.post()
        
        // Then
        switch result {
        case .success(_):
            XCTAssertTrue(mockSessionApi.dataCalled)
            XCTAssertEqual(mockSessionApi.lastRequest?.httpMethod, "POST")
        case .failure(let error):
            XCTFail("Expected success but got failure: \(error)")
        }
    }
    
    func testDeleteMethod() async {
        // Given
        sut = HttpSession(apiKey: "test-key", fullUrlPath: "https://api.fda.gov/food/enforcement.json", sessionApi: mockSessionApi)
        XCTAssertNotNil(sut)
        
        let mockResponse = FDARecallResponse(
            meta: Meta(disclaimer: "", terms: "", license: "", lastUpdated: "", results: MetaResults(skip: 0, limit: 0, total: 0)),
            results: []
        )
        
        let mockData = try! JSONEncoder().encode(mockResponse)
        let mockURLResponse = HTTPURLResponse(
            url: URL(string: "https://api.fda.gov/food/enforcement.json")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        
        mockSessionApi.mockResult = (mockData, mockURLResponse)
        
        // When
        let result: Result<FDARecallResponse, DataError> = await sut.delete()
        
        // Then
        switch result {
        case .success(_):
            XCTAssertTrue(mockSessionApi.dataCalled)
            XCTAssertEqual(mockSessionApi.lastRequest?.httpMethod, "DELETE")
        case .failure(let error):
            XCTFail("Expected success but got failure: \(error)")
        }
    }
    
    func testPutMethod() async {
        // Given
        sut = HttpSession(apiKey: "test-key", fullUrlPath: "https://api.fda.gov/food/enforcement.json", sessionApi: mockSessionApi)
        XCTAssertNotNil(sut)
        
        let mockResponse = FDARecallResponse(
            meta: Meta(disclaimer: "", terms: "", license: "", lastUpdated: "", results: MetaResults(skip: 0, limit: 0, total: 0)),
            results: []
        )
        
        let mockData = try! JSONEncoder().encode(mockResponse)
        let mockURLResponse = HTTPURLResponse(
            url: URL(string: "https://api.fda.gov/food/enforcement.json")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        
        mockSessionApi.mockResult = (mockData, mockURLResponse)
        
        // When
        let result: Result<FDARecallResponse, DataError> = await sut.put()
        
        // Then
        switch result {
        case .success(_):
            XCTAssertTrue(mockSessionApi.dataCalled)
            XCTAssertEqual(mockSessionApi.lastRequest?.httpMethod, "PUT")
        case .failure(let error):
            XCTFail("Expected success but got failure: \(error)")
        }
    }
}
