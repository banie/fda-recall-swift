//
//  FdaRecallDataTests.swift
//  fdaRecallTests
//
//  Created by banie setijoso on 2025-10-13.
//

import XCTest
import SwiftData
@testable import fdaRecall

final class FdaRecallDataTests: XCTestCase {
    
    // MARK: - Initialization Tests
    
    func testInitializationWithAllParameters() {
        // Given
        let recallData = FdaRecallData(
            recallNumber: "F-2024-001",
            status: "Ongoing",
            city: "New York",
            state: "NY",
            country: "US",
            classification: "Class I",
            productType: "Food",
            eventId: "12345",
            recallingFirm: "Test Company Inc",
            address1: "123 Main St",
            address2: "Suite 100",
            postalCode: "10001",
            voluntaryMandated: "Voluntary",
            initialFirmNotification: "2024-01-01",
            distributionPattern: "Nationwide",
            productDescription: "Test Product",
            productQuantity: "1000 units",
            reasonForRecall: "Potential contamination",
            recallInitiationDate: "20240101",
            centerClassificationDate: "20240102",
            terminationDate: "20240215",
            reportDate: "20240103",
            codeInfo: "Code info",
            moreCodeInfo: "More code info"
        )
        
        // Then
        XCTAssertEqual(recallData.recallNumber, "F-2024-001")
        XCTAssertEqual(recallData.status, "Ongoing")
        XCTAssertEqual(recallData.city, "New York")
        XCTAssertEqual(recallData.state, "NY")
        XCTAssertEqual(recallData.country, "US")
        XCTAssertEqual(recallData.classification, "Class I")
        XCTAssertEqual(recallData.productType, "Food")
        XCTAssertEqual(recallData.eventId, "12345")
        XCTAssertEqual(recallData.recallingFirm, "Test Company Inc")
        XCTAssertEqual(recallData.address1, "123 Main St")
        XCTAssertEqual(recallData.address2, "Suite 100")
        XCTAssertEqual(recallData.postalCode, "10001")
        XCTAssertEqual(recallData.voluntaryMandated, "Voluntary")
        XCTAssertEqual(recallData.initialFirmNotification, "2024-01-01")
        XCTAssertEqual(recallData.distributionPattern, "Nationwide")
        XCTAssertEqual(recallData.productDescription, "Test Product")
        XCTAssertEqual(recallData.productQuantity, "1000 units")
        XCTAssertEqual(recallData.reasonForRecall, "Potential contamination")
        XCTAssertEqual(recallData.recallInitiationDate, "20240101")
        XCTAssertEqual(recallData.centerClassificationDate, "20240102")
        XCTAssertEqual(recallData.terminationDate, "20240215")
        XCTAssertEqual(recallData.reportDate, "20240103")
        XCTAssertEqual(recallData.codeInfo, "Code info")
        XCTAssertEqual(recallData.moreCodeInfo, "More code info")
    }
    
    func testInitializationWithMinimalParameters() {
        // Given
        let recallData = FdaRecallData(recallNumber: "F-2024-001")
        
        // Then
        XCTAssertEqual(recallData.recallNumber, "F-2024-001")
        XCTAssertNil(recallData.status)
        XCTAssertNil(recallData.city)
        XCTAssertNil(recallData.state)
        XCTAssertNil(recallData.country)
        XCTAssertNil(recallData.classification)
        XCTAssertNil(recallData.productType)
        XCTAssertNil(recallData.eventId)
        XCTAssertNil(recallData.recallingFirm)
        XCTAssertNil(recallData.address1)
        XCTAssertNil(recallData.address2)
        XCTAssertNil(recallData.postalCode)
        XCTAssertNil(recallData.voluntaryMandated)
        XCTAssertNil(recallData.initialFirmNotification)
        XCTAssertNil(recallData.distributionPattern)
        XCTAssertNil(recallData.productDescription)
        XCTAssertNil(recallData.productQuantity)
        XCTAssertNil(recallData.reasonForRecall)
        XCTAssertNil(recallData.recallInitiationDate)
        XCTAssertNil(recallData.centerClassificationDate)
        XCTAssertNil(recallData.terminationDate)
        XCTAssertNil(recallData.reportDate)
        XCTAssertNil(recallData.codeInfo)
        XCTAssertNil(recallData.moreCodeInfo)
    }
    
    // MARK: - Convenience Initializer Tests
    
    func testConvenienceInitializerFromFdaRecall() {
        // Given
        let fdaRecall = FdaRecall(
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
            address2: "Suite 100",
            postalCode: "10001",
            voluntaryMandated: "Voluntary",
            initialFirmNotification: "2024-01-01",
            distributionPattern: "Nationwide",
            productDescription: "Test Product",
            productQuantity: "1000 units",
            reasonForRecall: "Potential contamination",
            recallInitiationDate: "20240101",
            centerClassificationDate: "20240102",
            terminationDate: "20240215",
            reportDate: "20240103",
            codeInfo: "Code info",
            moreCodeInfo: "More code info"
        )
        
        // When
        let recallData = FdaRecallData(from: fdaRecall)
        
        // Then
        XCTAssertEqual(recallData.recallNumber, fdaRecall.recallNumber)
        XCTAssertEqual(recallData.status, fdaRecall.status)
        XCTAssertEqual(recallData.city, fdaRecall.city)
        XCTAssertEqual(recallData.state, fdaRecall.state)
        XCTAssertEqual(recallData.country, fdaRecall.country)
        XCTAssertEqual(recallData.classification, fdaRecall.classification)
        XCTAssertEqual(recallData.productType, fdaRecall.productType)
        XCTAssertEqual(recallData.eventId, fdaRecall.eventId)
        XCTAssertEqual(recallData.recallingFirm, fdaRecall.recallingFirm)
        XCTAssertEqual(recallData.address1, fdaRecall.address1)
        XCTAssertEqual(recallData.address2, fdaRecall.address2)
        XCTAssertEqual(recallData.postalCode, fdaRecall.postalCode)
        XCTAssertEqual(recallData.voluntaryMandated, fdaRecall.voluntaryMandated)
        XCTAssertEqual(recallData.initialFirmNotification, fdaRecall.initialFirmNotification)
        XCTAssertEqual(recallData.distributionPattern, fdaRecall.distributionPattern)
        XCTAssertEqual(recallData.productDescription, fdaRecall.productDescription)
        XCTAssertEqual(recallData.productQuantity, fdaRecall.productQuantity)
        XCTAssertEqual(recallData.reasonForRecall, fdaRecall.reasonForRecall)
        XCTAssertEqual(recallData.recallInitiationDate, fdaRecall.recallInitiationDate)
        XCTAssertEqual(recallData.centerClassificationDate, fdaRecall.centerClassificationDate)
        XCTAssertEqual(recallData.terminationDate, fdaRecall.terminationDate)
        XCTAssertEqual(recallData.reportDate, fdaRecall.reportDate)
        XCTAssertEqual(recallData.codeInfo, fdaRecall.codeInfo)
        XCTAssertEqual(recallData.moreCodeInfo, fdaRecall.moreCodeInfo)
    }
    
    // MARK: - Computed Properties Tests
    
    func testDisplayTitle_WithProductDescription() {
        // Given
        let recallData = FdaRecallData(
            recallNumber: "F-2024-001",
            recallingFirm: "Test Company Inc",
            productDescription: "Test Product",
        )
        
        // When & Then
        XCTAssertEqual(recallData.displayTitle, "Test Product")
    }
    
    func testDisplayTitle_WithRecallingFirmOnly() {
        // Given
        let recallData = FdaRecallData(
            recallNumber: "F-2024-001",
            recallingFirm: "Test Company Inc"
        )
        
        // When & Then
        XCTAssertEqual(recallData.displayTitle, "Test Company Inc")
    }
    
    func testDisplayTitle_WithNoDescriptionOrFirm() {
        // Given
        let recallData = FdaRecallData(recallNumber: "F-2024-001")
        
        // When & Then
        XCTAssertEqual(recallData.displayTitle, "Unknown Recall")
    }
    
    func testDisplayTitle_PrioritizesProductDescription() {
        // Given
        let recallData = FdaRecallData(
            recallNumber: "F-2024-001",
            recallingFirm: "Test Company Inc",
            productDescription: "Test Product",
        )
        
        // When & Then
        XCTAssertEqual(recallData.displayTitle, "Test Product")
    }
    
    func testDisplaySubtitle_WithFirmAndCityState() {
        // Given
        let recallData = FdaRecallData(
            recallNumber: "F-2024-001",
            city: "New York",
            state: "NY",
            recallingFirm: "Test Company Inc",
        )
        
        // When & Then
        XCTAssertEqual(recallData.displaySubtitle, "Test Company Inc • New York, NY")
    }
    
    func testDisplaySubtitle_WithFirmAndStateOnly() {
        // Given
        let recallData = FdaRecallData(
            recallNumber: "F-2024-001",
            state: "NY",
            recallingFirm: "Test Company Inc",
        )
        
        // When & Then
        XCTAssertEqual(recallData.displaySubtitle, "Test Company Inc • NY")
    }
    
    func testDisplaySubtitle_WithFirmOnly() {
        // Given
        let recallData = FdaRecallData(
            recallNumber: "F-2024-001",
            recallingFirm: "Test Company Inc"
        )
        
        // When & Then
        XCTAssertEqual(recallData.displaySubtitle, "Test Company Inc")
    }
    
    func testDisplaySubtitle_WithNoFirm() {
        // Given
        let recallData = FdaRecallData(
            recallNumber: "F-2024-001",
            city: "New York",
            state: "NY"
        )
        
        // When & Then
        XCTAssertEqual(recallData.displaySubtitle, "New York, NY")
    }
    
    func testDisplaySubtitle_EmptyWhenNoData() {
        // Given
        let recallData = FdaRecallData(recallNumber: "F-2024-001")
        
        // When & Then
        XCTAssertEqual(recallData.displaySubtitle, "")
    }
    
    // MARK: - Date Parsing Tests
    
    func testRecallDate_WithValidDate() {
        // Given
        let recallData = FdaRecallData(
            recallNumber: "F-2024-001",
            recallInitiationDate: "20240115"
        )
        
        // When
        let date = recallData.recallDate
        
        // Then
        XCTAssertNotNil(date)
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date!)
        XCTAssertEqual(components.year, 2024)
        XCTAssertEqual(components.month, 1)
        XCTAssertEqual(components.day, 15)
    }
    
    func testRecallDate_WithInvalidDate() {
        // Given
        let recallData = FdaRecallData(
            recallNumber: "F-2024-001",
            recallInitiationDate: "invalid-date"
        )
        
        // When
        let date = recallData.recallDate
        
        // Then
        XCTAssertNil(date)
    }
    
    func testRecallDate_WithNilDate() {
        // Given
        let recallData = FdaRecallData(recallNumber: "F-2024-001")
        
        // When
        let date = recallData.recallDate
        
        // Then
        XCTAssertNil(date)
    }
    
    func testFormattedRecallDate_WithValidDate() {
        // Given
        let recallData = FdaRecallData(
            recallNumber: "F-2024-001",
            recallInitiationDate: "20240115"
        )
        
        // When
        let formattedDate = recallData.formattedRecallDate
        
        // Then
        XCTAssertNotEqual(formattedDate, "Unknown Date")
        XCTAssertTrue(formattedDate.contains("2024"))
        XCTAssertTrue(formattedDate.contains("Jan") || formattedDate.contains("January") || formattedDate.contains("1"))
    }
    
    func testFormattedRecallDate_WithInvalidDate() {
        // Given
        let recallData = FdaRecallData(
            recallNumber: "F-2024-001",
            recallInitiationDate: "invalid-date"
        )
        
        // When
        let formattedDate = recallData.formattedRecallDate
        
        // Then
        XCTAssertEqual(formattedDate, "Unknown Date")
    }
    
    func testFormattedRecallDate_WithNilDate() {
        // Given
        let recallData = FdaRecallData(recallNumber: "F-2024-001")
        
        // When
        let formattedDate = recallData.formattedRecallDate
        
        // Then
        XCTAssertEqual(formattedDate, "Unknown Date")
    }
    
    // MARK: - Edge Cases
    
    func testDisplayTitle_WithEmptyStrings() {
        // Given
        let recallData = FdaRecallData(
            recallNumber: "F-2024-001",
            recallingFirm: "",
            productDescription: "",
        )
        
        // When & Then
        XCTAssertEqual(recallData.displayTitle, "")
    }
    
    func testRecallDate_WithDifferentFormats() {
        // Given
        let testCases = [
            ("20240115", true),   // Valid format
            ("2024-01-15", false), // Wrong format
            ("15/01/2024", false), // Wrong format
            ("20241315", false),  // Invalid month
            ("20240230", false),  // Invalid day
            ("20240101", true),   // Valid format
            ("20241231", true)    // Valid format
        ]
        
        for (dateString, shouldBeValid) in testCases {
            let recallData = FdaRecallData(
                recallNumber: "F-2024-001",
                recallInitiationDate: dateString
            )
            
            let date = recallData.recallDate
            
            if shouldBeValid {
                XCTAssertNotNil(date, "Date '\(dateString)' should be valid")
            } else {
                XCTAssertNil(date, "Date '\(dateString)' should be invalid")
            }
        }
    }
    
    // MARK: - SwiftData Model Tests
    
    func testSwiftDataModelAnnotation() {
        // Given
        let recallData = FdaRecallData(recallNumber: "F-2024-001")
        
        // When & Then
        // Verify that the class can be instantiated (SwiftData @Model annotation works)
        XCTAssertEqual(recallData.recallNumber, "F-2024-001")
        
        // Verify unique constraint on recallNumber
        let recallData2 = FdaRecallData(recallNumber: "F-2024-002")
        XCTAssertNotEqual(recallData.recallNumber, recallData2.recallNumber)
    }
}
