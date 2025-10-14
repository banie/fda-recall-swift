//
//  TestHelpers.swift
//  fdaRecallTests
//
//  Created by banie setijoso on 2025-10-13.
//

import Foundation
import XCTest
@testable import fdaRecall

// MARK: - Test Data Factory

struct TestDataFactory {
    
    // MARK: - FdaRecall Test Data
    
    static func createFdaRecall(
        recallNumber: String = "F-2024-001",
        status: String? = "Ongoing",
        city: String? = "New York",
        state: String? = "NY",
        country: String? = "US",
        classification: String? = "Class I",
        productType: String? = "Food",
        eventId: String? = "12345",
        recallingFirm: String? = "Test Company Inc",
        address1: String? = "123 Main St",
        address2: String? = "Suite 100",
        postalCode: String? = "10001",
        voluntaryMandated: String? = "Voluntary",
        initialFirmNotification: String? = "2024-01-01",
        distributionPattern: String? = "Nationwide",
        productDescription: String? = "Test Product",
        productQuantity: String? = "1000 units",
        reasonForRecall: String? = "Potential contamination",
        recallInitiationDate: String? = "20240101",
        centerClassificationDate: String? = "20240102",
        terminationDate: String? = "20240215",
        reportDate: String? = "20240103",
        codeInfo: String? = "Code info",
        moreCodeInfo: String? = "More code info"
    ) -> FdaRecall {
        return FdaRecall(
            recallNumber: recallNumber,
            status: status,
            city: city,
            state: state,
            country: country,
            classification: classification,
            openfda: OpenFDA(),
            productType: productType,
            eventId: eventId,
            recallingFirm: recallingFirm,
            address1: address1,
            address2: address2,
            postalCode: postalCode,
            voluntaryMandated: voluntaryMandated,
            initialFirmNotification: initialFirmNotification,
            distributionPattern: distributionPattern,
            productDescription: productDescription,
            productQuantity: productQuantity,
            reasonForRecall: reasonForRecall,
            recallInitiationDate: recallInitiationDate,
            centerClassificationDate: centerClassificationDate,
            terminationDate: terminationDate,
            reportDate: reportDate,
            codeInfo: codeInfo,
            moreCodeInfo: moreCodeInfo
        )
    }
    
    static func createFdaRecalls(count: Int = 2) -> [FdaRecall] {
        var recalls: [FdaRecall] = []
        
        for i in 0..<count {
            let recall = createFdaRecall(
                recallNumber: "F-2024-\(String(format: "%03d", i + 1))",
                city: "Test City \(i)",
                recallingFirm: "Test Company \(i) Inc",
                address1: "\(123 + i) Main St",
                postalCode: "\(10001 + i)",
                productDescription: "Test Product \(i)",
                productQuantity: "\(1000 + i) units",
                codeInfo: "Code info \(i)",
                moreCodeInfo: "More code info \(i)"
            )
            recalls.append(recall)
        }
        
        return recalls
    }
    
    // MARK: - FDARecallResponse Test Data
    
    static func createFDARecallResponse(
        disclaimer: String = "Test disclaimer",
        terms: String = "Test terms",
        license: String = "Test license",
        lastUpdated: String = "2024-01-01",
        skip: Int = 0,
        limit: Int = 10,
        total: Int = 1,
        recalls: [FdaRecall]? = nil
    ) -> FDARecallResponse {
        let meta = Meta(
            disclaimer: disclaimer,
            terms: terms,
            license: license,
            lastUpdated: lastUpdated,
            results: MetaResults(skip: skip, limit: limit, total: total)
        )
        
        let results = recalls ?? createFdaRecalls()
        
        return FDARecallResponse(meta: meta, results: results)
    }
    
    // MARK: - FdaRecallData Test Data
    
    static func createFdaRecallData(
        recallNumber: String = "F-2024-001",
        status: String? = "Ongoing",
        city: String? = "New York",
        state: String? = "NY",
        country: String? = "US",
        classification: String? = "Class I",
        productType: String? = "Food",
        eventId: String? = "12345",
        recallingFirm: String? = "Test Company Inc",
        address1: String? = "123 Main St",
        address2: String? = "Suite 100",
        postalCode: String? = "10001",
        voluntaryMandated: String? = "Voluntary",
        initialFirmNotification: String? = "2024-01-01",
        distributionPattern: String? = "Nationwide",
        productDescription: String? = "Test Product",
        productQuantity: String? = "1000 units",
        reasonForRecall: String? = "Potential contamination",
        recallInitiationDate: String? = "20240101",
        centerClassificationDate: String? = "20240102",
        terminationDate: String? = "20240215",
        reportDate: String? = "20240103",
        codeInfo: String? = "Code info",
        moreCodeInfo: String? = "More code info"
    ) -> FdaRecallData {
        return FdaRecallData(
            recallNumber: recallNumber,
            status: status,
            city: city,
            state: state,
            country: country,
            classification: classification,
            productType: productType,
            eventId: eventId,
            recallingFirm: recallingFirm,
            address1: address1,
            address2: address2,
            postalCode: postalCode,
            voluntaryMandated: voluntaryMandated,
            initialFirmNotification: initialFirmNotification,
            distributionPattern: distributionPattern,
            productDescription: productDescription,
            productQuantity: productQuantity,
            reasonForRecall: reasonForRecall,
            recallInitiationDate: recallInitiationDate,
            centerClassificationDate: centerClassificationDate,
            terminationDate: terminationDate,
            reportDate: reportDate,
            codeInfo: codeInfo,
            moreCodeInfo: moreCodeInfo
        )
    }
    
    // MARK: - JSON Test Data
    
    static func createValidFDAResponseJSON() -> String {
        return """
        {
            "meta": {
                "disclaimer": "Test disclaimer",
                "terms": "Test terms",
                "license": "Test license",
                "last_updated": "2024-01-01",
                "results": {
                    "skip": 0,
                    "limit": 10,
                    "total": 1
                }
            },
            "results": [
                {
                    "recall_number": "F-2024-001",
                    "status": "Ongoing",
                    "city": "New York",
                    "state": "NY",
                    "country": "US",
                    "classification": "Class I",
                    "openfda": {},
                    "product_type": "Food",
                    "event_id": "12345",
                    "recalling_firm": "Test Company Inc",
                    "address_1": "123 Main St",
                    "address_2": "Suite 100",
                    "postal_code": "10001",
                    "voluntary_mandated": "Voluntary",
                    "initial_firm_notification": "2024-01-01",
                    "distribution_pattern": "Nationwide",
                    "product_description": "Test Product",
                    "product_quantity": "1000 units",
                    "reason_for_recall": "Potential contamination",
                    "recall_initiation_date": "20240101",
                    "center_classification_date": "20240102",
                    "termination_date": "20240215",
                    "report_date": "20240103",
                    "code_info": "Code info",
                    "more_code_info": "More code info"
                }
            ]
        }
        """
    }
    
    static func createEmptyFDAResponseJSON() -> String {
        return """
        {
            "meta": {
                "disclaimer": "Test disclaimer",
                "terms": "Test terms",
                "license": "Test license",
                "last_updated": "2024-01-01",
                "results": {
                    "skip": 0,
                    "limit": 10,
                    "total": 0
                }
            },
            "results": []
        }
        """
    }
    
    static func createInvalidJSON() -> String {
        return """
        {
            "meta": {
                "disclaimer": "Test disclaimer",
                "terms": "Test terms",
                "license": "Test license",
                "last_updated": "2024-01-01",
                "results": {
                    "skip": 0,
                    "limit": 10,
                    "total": 1
                }
            },
            "results": [
                {
                    "status": "Ongoing"
                }
            ]
        }
        """
    }
}

// MARK: - Test Assertions

struct TestAssertions {
    
    static func assertFdaRecallEqual(_ actual: FdaRecall, _ expected: FdaRecall, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(actual.recallNumber, expected.recallNumber, file: file, line: line)
        XCTAssertEqual(actual.status, expected.status, file: file, line: line)
        XCTAssertEqual(actual.city, expected.city, file: file, line: line)
        XCTAssertEqual(actual.state, expected.state, file: file, line: line)
        XCTAssertEqual(actual.country, expected.country, file: file, line: line)
        XCTAssertEqual(actual.classification, expected.classification, file: file, line: line)
        XCTAssertEqual(actual.productType, expected.productType, file: file, line: line)
        XCTAssertEqual(actual.eventId, expected.eventId, file: file, line: line)
        XCTAssertEqual(actual.recallingFirm, expected.recallingFirm, file: file, line: line)
        XCTAssertEqual(actual.address1, expected.address1, file: file, line: line)
        XCTAssertEqual(actual.address2, expected.address2, file: file, line: line)
        XCTAssertEqual(actual.postalCode, expected.postalCode, file: file, line: line)
        XCTAssertEqual(actual.voluntaryMandated, expected.voluntaryMandated, file: file, line: line)
        XCTAssertEqual(actual.initialFirmNotification, expected.initialFirmNotification, file: file, line: line)
        XCTAssertEqual(actual.distributionPattern, expected.distributionPattern, file: file, line: line)
        XCTAssertEqual(actual.productDescription, expected.productDescription, file: file, line: line)
        XCTAssertEqual(actual.productQuantity, expected.productQuantity, file: file, line: line)
        XCTAssertEqual(actual.reasonForRecall, expected.reasonForRecall, file: file, line: line)
        XCTAssertEqual(actual.recallInitiationDate, expected.recallInitiationDate, file: file, line: line)
        XCTAssertEqual(actual.centerClassificationDate, expected.centerClassificationDate, file: file, line: line)
        XCTAssertEqual(actual.terminationDate, expected.terminationDate, file: file, line: line)
        XCTAssertEqual(actual.reportDate, expected.reportDate, file: file, line: line)
        XCTAssertEqual(actual.codeInfo, expected.codeInfo, file: file, line: line)
        XCTAssertEqual(actual.moreCodeInfo, expected.moreCodeInfo, file: file, line: line)
    }
    
    static func assertFdaRecallDataEqual(_ actual: FdaRecallData, _ expected: FdaRecallData, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(actual.recallNumber, expected.recallNumber, file: file, line: line)
        XCTAssertEqual(actual.status, expected.status, file: file, line: line)
        XCTAssertEqual(actual.city, expected.city, file: file, line: line)
        XCTAssertEqual(actual.state, expected.state, file: file, line: line)
        XCTAssertEqual(actual.country, expected.country, file: file, line: line)
        XCTAssertEqual(actual.classification, expected.classification, file: file, line: line)
        XCTAssertEqual(actual.productType, expected.productType, file: file, line: line)
        XCTAssertEqual(actual.eventId, expected.eventId, file: file, line: line)
        XCTAssertEqual(actual.recallingFirm, expected.recallingFirm, file: file, line: line)
        XCTAssertEqual(actual.address1, expected.address1, file: file, line: line)
        XCTAssertEqual(actual.address2, expected.address2, file: file, line: line)
        XCTAssertEqual(actual.postalCode, expected.postalCode, file: file, line: line)
        XCTAssertEqual(actual.voluntaryMandated, expected.voluntaryMandated, file: file, line: line)
        XCTAssertEqual(actual.initialFirmNotification, expected.initialFirmNotification, file: file, line: line)
        XCTAssertEqual(actual.distributionPattern, expected.distributionPattern, file: file, line: line)
        XCTAssertEqual(actual.productDescription, expected.productDescription, file: file, line: line)
        XCTAssertEqual(actual.productQuantity, expected.productQuantity, file: file, line: line)
        XCTAssertEqual(actual.reasonForRecall, expected.reasonForRecall, file: file, line: line)
        XCTAssertEqual(actual.recallInitiationDate, expected.recallInitiationDate, file: file, line: line)
        XCTAssertEqual(actual.centerClassificationDate, expected.centerClassificationDate, file: file, line: line)
        XCTAssertEqual(actual.terminationDate, expected.terminationDate, file: file, line: line)
        XCTAssertEqual(actual.reportDate, expected.reportDate, file: file, line: line)
        XCTAssertEqual(actual.codeInfo, expected.codeInfo, file: file, line: line)
        XCTAssertEqual(actual.moreCodeInfo, expected.moreCodeInfo, file: file, line: line)
    }
}

// MARK: - Test Constants

struct TestConstants {
    static let baseURL = "https://api.fda.gov/food/enforcement.json"
    static let testAPIKey = "test-api-key"
    static let fetchLimit = 20
    static let testRecallNumber = "F-2024-001"
    static let testFirmName = "Test Company Inc"
    static let testProductDescription = "Test Product"
    static let testCity = "New York"
    static let testState = "NY"
    static let testCountry = "US"
    static let testClassification = "Class I"
    static let testProductType = "Food"
    static let testEventId = "12345"
    static let testAddress1 = "123 Main St"
    static let testAddress2 = "Suite 100"
    static let testPostalCode = "10001"
    static let testVoluntaryMandated = "Voluntary"
    static let testInitialFirmNotification = "2024-01-01"
    static let testDistributionPattern = "Nationwide"
    static let testProductQuantity = "1000 units"
    static let testReasonForRecall = "Potential contamination"
    static let testRecallInitiationDate = "20240101"
    static let testCenterClassificationDate = "20240102"
    static let testTerminationDate = "20240215"
    static let testReportDate = "20240103"
    static let testCodeInfo = "Code info"
    static let testMoreCodeInfo = "More code info"
}
