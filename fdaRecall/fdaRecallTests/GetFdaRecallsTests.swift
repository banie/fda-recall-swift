//
//  GetFdaRecallsTests.swift
//  fdaRecallTests
//
//  Created by banie setijoso on 2025-10-13.
//

import XCTest
import Foundation
@testable import fdaRecall

@MainActor final class GetFdaRecallsTests: XCTestCase {
    
    var sut: GetFdaRecallsImpl!
    var mockSessionApi: MockSessionApi!
    var httpSession: HttpSession!
    
    override func setUp() {
        super.setUp()
        mockSessionApi = MockSessionApi()
        httpSession = HttpSession(apiKey: "test-key", fullUrlPath: "https://api.fda.gov/food/enforcement.json", sessionApi: mockSessionApi)
        sut = GetFdaRecallsImpl(httpSession: httpSession)
    }
    
    override func tearDown() {
        sut = nil
        httpSession = nil
        mockSessionApi = nil
        super.tearDown()
    }
    
    // MARK: - Success Cases
    
    func testFetchSuccess_WithValidResponse() async {
        // Given
        let expectedRecalls = createMockFdaRecalls()
        let mockResponse = FDARecallResponse(
            meta: createMockMeta(),
            results: expectedRecalls
        )
        let encoder = JSONEncoder()
        let data = try! encoder.encode(mockResponse)
        let url = URL(string: "https://api.fda.gov/food/enforcement.json")!
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        mockSessionApi.mockResult = (data, response)
        mockSessionApi.shouldThrowError = false
        
        // When
        let result = await sut.fetch(skip: 0, limit: 10)
        
        // Then
        switch result {
        case .success(let recalls):
            XCTAssertEqual(recalls.count, 2)
            XCTAssertEqual(recalls[0].recallNumber, "F-2024-001")
            XCTAssertEqual(recalls[1].recallNumber, "F-2024-002")
        case .failure(let error):
            XCTFail("Expected success but got failure: \(error)")
        }
        
        // Verify HttpSession was called with correct parameters
        XCTAssertTrue(mockSessionApi.dataCalled)
        guard let lastRequest = mockSessionApi.lastRequest else {
            XCTFail("No request captured")
            return
        }
        let urlComponents = URLComponents(url: lastRequest.url!, resolvingAgainstBaseURL: false)
        let queryItems = urlComponents?.queryItems ?? []
        func value(for key: String) -> String? {
            return queryItems.first(where: { $0.name == key })?.value
        }
        XCTAssertEqual(value(for: "skip"), "0")
        XCTAssertEqual(value(for: "limit"), "10")
        XCTAssertEqual(value(for: "sort"), "recall_initiation_date:desc")
    }
    
    func testFetchSuccess_WithNilParameters() async {
        // Given
        let expectedRecalls = createMockFdaRecalls()
        let mockResponse = FDARecallResponse(
            meta: createMockMeta(),
            results: expectedRecalls
        )
        let encoder = JSONEncoder()
        let data = try! encoder.encode(mockResponse)
        let url = URL(string: "https://api.fda.gov/food/enforcement.json")!
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        mockSessionApi.mockResult = (data, response)
        mockSessionApi.shouldThrowError = false
        
        // When
        let result = await sut.fetch(skip: nil, limit: nil)
        
        // Then
        switch result {
        case .success(let recalls):
            XCTAssertEqual(recalls.count, 2)
        case .failure(let error):
            XCTFail("Expected success but got failure: \(error)")
        }
        
        // Verify HttpSession was called with only sort parameter
        XCTAssertTrue(mockSessionApi.dataCalled)
        guard let lastRequest = mockSessionApi.lastRequest else {
            XCTFail("No request captured")
            return
        }
        let urlComponents = URLComponents(url: lastRequest.url!, resolvingAgainstBaseURL: false)
        let queryItems = urlComponents?.queryItems ?? []
        func value(for key: String) -> String? {
            return queryItems.first(where: { $0.name == key })?.value
        }
        XCTAssertNil(value(for: "skip"))
        XCTAssertNil(value(for: "limit"))
        XCTAssertEqual(value(for: "sort"), "recall_initiation_date:desc")
    }
    
    func testFetchSuccess_WithEmptyResults() async {
        // Given
        let mockResponse = FDARecallResponse(
            meta: createMockMeta(),
            results: []
        )
        let encoder = JSONEncoder()
        let data = try! encoder.encode(mockResponse)
        let url = URL(string: "https://api.fda.gov/food/enforcement.json")!
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        mockSessionApi.mockResult = (data, response)
        mockSessionApi.shouldThrowError = false
        
        // When
        let result = await sut.fetch(skip: 0, limit: 10)
        
        // Then
        switch result {
        case .success(let recalls):
            XCTAssertTrue(recalls.isEmpty)
        case .failure(let error):
            XCTFail("Expected success but got failure: \(error)")
        }
    }
    
    // MARK: - Error Cases
    
    func testFetchFailure_WithHttpError() async {
        // Given
        mockSessionApi.shouldThrowError = false
        let errorResponse = HTTPURLResponse(url: URL(string: "https://api.fda.gov/food/enforcement.json")!, statusCode: 500, httpVersion: nil, headerFields: nil)!
        let errorData = "{\"error\":\"Internal Server Error\"}".data(using: .utf8)!
        mockSessionApi.mockResult = (errorData, errorResponse)
        
        // When
        let result = await sut.fetch(skip: 0, limit: 10)
        
        // Then
        switch result {
        case .success(_):
            XCTFail("Expected failure but got success")
        case .failure(let error):
            if case .httpError(let status, _) = error {
                XCTAssertEqual(status, HTTPStatusCode.internalServerError)
            } else {
                XCTFail("Expected httpError but got: \(error)")
            }
        }
    }
    
    func testFetchFailure_WithParsingError() async {
        // Given
        mockSessionApi.shouldThrowError = false
        let invalidJsonData = "invalid json data".data(using: .utf8)!
        let response = HTTPURLResponse(url: URL(string: "https://api.fda.gov/food/enforcement.json")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        mockSessionApi.mockResult = (invalidJsonData, response)
        
        // When
        let result = await sut.fetch(skip: 0, limit: 10)
        
        // Then
        switch result {
        case .success(_):
            XCTFail("Expected failure but got success")
        case .failure(let error):
            if case .parsingError(_, let data) = error {
                XCTAssertEqual(data, "invalid json data")
            } else {
                XCTFail("Expected parsingError but got: \(error)")
            }
        }
    }
    
    func testFetchFailure_WithSessionError() async {
        // Given
        mockSessionApi.shouldThrowError = true
        mockSessionApi.mockError = URLError(.notConnectedToInternet)
        
        // When
        let result = await sut.fetch(skip: 0, limit: 10)
        
        // Then
        switch result {
        case .success(_):
            XCTFail("Expected failure but got success")
        case .failure(let error):
            if case .sessionError(let message) = error {
                XCTAssertTrue(message.contains("The operation couldn’t be completed") || message.contains("not connected"))
            } else {
                XCTFail("Expected sessionError but got: \(error)")
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func createMockFdaRecalls() -> [FdaRecall] {
        return [
            FdaRecall(
                recallNumber: "F-2024-001",
                status: "Ongoing",
                city: "New York",
                state: "NY",
                country: "US",
                classification: "Class I",
                openfda: nil,
                productType: "Food",
                eventId: "12345",
                recallingFirm: "Test Company Inc",
                address1: "123 Main St",
                address2: nil,
                postalCode: "10001",
                voluntaryMandated: "Voluntary",
                initialFirmNotification: "2024-01-01",
                distributionPattern: "Nationwide",
                productDescription: "Test Product",
                productQuantity: "1000 units",
                reasonForRecall: "Potential contamination",
                recallInitiationDate: "20240101",
                centerClassificationDate: "20240102",
                terminationDate: nil,
                reportDate: "20240103",
                codeInfo: "Code info",
                moreCodeInfo: "More code info"
            ),
            FdaRecall(
                recallNumber: "F-2024-002",
                status: "Terminated",
                city: "Los Angeles",
                state: "CA",
                country: "US",
                classification: "Class II",
                openfda: nil,
                productType: "Food",
                eventId: "12346",
                recallingFirm: "Another Company LLC",
                address1: "456 Oak Ave",
                address2: "Suite 100",
                postalCode: "90210",
                voluntaryMandated: "Mandated",
                initialFirmNotification: "2024-02-01",
                distributionPattern: "Regional",
                productDescription: "Another Test Product",
                productQuantity: "500 units",
                reasonForRecall: "Mislabeling",
                recallInitiationDate: "20240201",
                centerClassificationDate: "20240202",
                terminationDate: "20240215",
                reportDate: "20240203",
                codeInfo: "Another code info",
                moreCodeInfo: "Another more code info"
            )
        ]
    }
    
    private func createMockMeta() -> Meta {
        return Meta(
            disclaimer: "Test disclaimer",
            terms: "Test terms",
            license: "Test license",
            lastUpdated: "2024-01-01",
            results: MetaResults(skip: 0, limit: 10, total: 2)
        )
    }
}

// MARK: - MockSessionApi from HttpSessionTests.swift


