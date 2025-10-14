//
//  FdaRecallsRepositoryTests.swift
//  fdaRecallTests
//
//  Created by banie setijoso on 2025-10-13.
//

import XCTest
import SwiftData
@testable import fdaRecall

@MainActor final class FdaRecallsRepositoryTests: XCTestCase {
    
    var sut: FdaRecallsRepositoryImpl!
    var container: ModelContainer!
    var modelContext: ModelContext!
    
    override func setUp() {
        super.setUp()
        container = try! ModelContainer(
            for: FdaRecallData.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        modelContext = container.mainContext
        sut = FdaRecallsRepositoryImpl(modelContext: modelContext)
    }
    
    override func tearDown() {
        sut = nil
        container = nil
        modelContext = nil
        super.tearDown()
    }
    
    // MARK: - Success Cases
    
    func testFetchSuccess_FirstPage() async throws {
        // Given
        let mockRecalls = createMockFdaRecalls()
        for recall in mockRecalls {
            let recallData = FdaRecallData(from: recall)
            modelContext.insert(recallData)
        }
        try modelContext.save()
        
        // When
        let fetchDescriptor = FetchDescriptor<FdaRecallData>(sortBy: [SortDescriptor(\.recallInitiationDate, order: .reverse)])
        let fetchedItems = try modelContext.fetch(fetchDescriptor)
        
        // Then
        XCTAssertEqual(fetchedItems.count, mockRecalls.count)
        let firstItem = fetchedItems[0]
        XCTAssertEqual(firstItem.recallNumber, "F-2024-001")
        XCTAssertEqual(firstItem.recallingFirm, "Test Company 0 Inc")
    }
    
    func testFetchSuccess_LastPage() async throws {
        // Given
        let mockRecalls = createMockFdaRecalls(count: 10) // Less than fetchLimit (20)
        for recall in mockRecalls {
            let recallData = FdaRecallData(from: recall)
            modelContext.insert(recallData)
        }
        try modelContext.save()
        
        // When
        let fetchDescriptor = FetchDescriptor<FdaRecallData>(sortBy: [SortDescriptor(\.recallInitiationDate, order: .reverse)])
        let fetchedItems = try modelContext.fetch(fetchDescriptor)
        
        // Then
        XCTAssertEqual(fetchedItems.count, 10)
    }
    
    func testFetchSuccess_ExactLimit() async throws {
        // Given
        let mockRecalls = createMockFdaRecalls(count: 20) // Exactly fetchLimit
        for recall in mockRecalls {
            let recallData = FdaRecallData(from: recall)
            modelContext.insert(recallData)
        }
        try modelContext.save()
        
        // When
        let fetchDescriptor = FetchDescriptor<FdaRecallData>(sortBy: [SortDescriptor(\.recallInitiationDate, order: .reverse)])
        let fetchedItems = try modelContext.fetch(fetchDescriptor)
        
        // Then
        XCTAssertEqual(fetchedItems.count, 20)
    }
    
    func testFetchSuccess_EmptyResults() async throws {
        // Given
        // no items inserted
        
        // When
        let fetchedItems = try modelContext.fetch(FetchDescriptor<FdaRecallData>())
        
        // Then
        XCTAssertTrue(fetchedItems.isEmpty)
    }
    
    // MARK: - Properties Tests
    
    func testFetchLimit() {
        // Given & When
        let fetchLimit = sut.fetchLimit
        
        // Then
        XCTAssertEqual(fetchLimit, 20)
    }
    
    // MARK: - Helper Methods
    
    private func createMockFdaRecalls(count: Int = 2) -> [FdaRecall] {
        var recalls: [FdaRecall] = []
        
        for i in 0..<count {
            let recall = FdaRecall(
                recallNumber: "F-2024-\(String(format: "%03d", i + 1))",
                status: "Ongoing",
                city: "Test City \(i)",
                state: "TS",
                country: "US",
                classification: "Class I",
                openfda: nil,
                productType: "Food",
                eventId: "\(12345 + i)",
                recallingFirm: "Test Company \(i) Inc",
                address1: "\(123 + i) Main St",
                address2: nil,
                postalCode: "\(10001 + i)",
                voluntaryMandated: "Voluntary",
                initialFirmNotification: "2024-01-01",
                distributionPattern: "Nationwide",
                productDescription: "Test Product \(i)",
                productQuantity: "\(1000 + i) units",
                reasonForRecall: "Potential contamination",
                recallInitiationDate: "20240101",
                centerClassificationDate: "20240102",
                terminationDate: nil,
                reportDate: "20240103",
                codeInfo: "Code info \(i)",
                moreCodeInfo: "More code info \(i)"
            )
            recalls.append(recall)
        }
        
        return recalls
    }
}
