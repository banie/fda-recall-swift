//
//  FDARecallResponseTests.swift
//  fdaRecallTests
//
//  Created by banie setijoso on 2025-10-13.
//

import XCTest
@preconcurrency import Foundation
@testable import fdaRecall

@MainActor final class FDARecallResponseTests: XCTestCase {
    
    // MARK: - FDARecallResponse Tests
    
    func testFDARecallResponseDecoding() throws {
        // Given
        let jsonString = """
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
        
        let jsonData = jsonString.data(using: .utf8)!
        
        // When
        let response = try JSONDecoder().decode(FDARecallResponse.self, from: jsonData)
        
        // Then
        XCTAssertEqual(response.meta.disclaimer, "Test disclaimer")
        XCTAssertEqual(response.meta.terms, "Test terms")
        XCTAssertEqual(response.meta.license, "Test license")
        XCTAssertEqual(response.meta.lastUpdated, "2024-01-01")
        XCTAssertEqual(response.meta.results.skip, 0)
        XCTAssertEqual(response.meta.results.limit, 10)
        XCTAssertEqual(response.meta.results.total, 1)
        
        XCTAssertEqual(response.results.count, 1)
        
        let recall = response.results[0]
        XCTAssertEqual(recall.recallNumber, "F-2024-001")
        XCTAssertEqual(recall.status, "Ongoing")
        XCTAssertEqual(recall.city, "New York")
        XCTAssertEqual(recall.state, "NY")
        XCTAssertEqual(recall.country, "US")
        XCTAssertEqual(recall.classification, "Class I")
        XCTAssertEqual(recall.productType, "Food")
        XCTAssertEqual(recall.eventId, "12345")
        XCTAssertEqual(recall.recallingFirm, "Test Company Inc")
        XCTAssertEqual(recall.address1, "123 Main St")
        XCTAssertEqual(recall.address2, "Suite 100")
        XCTAssertEqual(recall.postalCode, "10001")
        XCTAssertEqual(recall.voluntaryMandated, "Voluntary")
        XCTAssertEqual(recall.initialFirmNotification, "2024-01-01")
        XCTAssertEqual(recall.distributionPattern, "Nationwide")
        XCTAssertEqual(recall.productDescription, "Test Product")
        XCTAssertEqual(recall.productQuantity, "1000 units")
        XCTAssertEqual(recall.reasonForRecall, "Potential contamination")
        XCTAssertEqual(recall.recallInitiationDate, "20240101")
        XCTAssertEqual(recall.centerClassificationDate, "20240102")
        XCTAssertEqual(recall.terminationDate, "20240215")
        XCTAssertEqual(recall.reportDate, "20240103")
        XCTAssertEqual(recall.codeInfo, "Code info")
        XCTAssertEqual(recall.moreCodeInfo, "More code info")
    }
    
    func testFDARecallResponseDecodingWithNullValues() throws {
        // Given
        let jsonString = """
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
                    "status": null,
                    "city": null,
                    "state": null,
                    "country": null,
                    "classification": null,
                    "openfda": null,
                    "product_type": null,
                    "event_id": null,
                    "recalling_firm": null,
                    "address_1": null,
                    "address_2": null,
                    "postal_code": null,
                    "voluntary_mandated": null,
                    "initial_firm_notification": null,
                    "distribution_pattern": null,
                    "product_description": null,
                    "product_quantity": null,
                    "reason_for_recall": null,
                    "recall_initiation_date": null,
                    "center_classification_date": null,
                    "termination_date": null,
                    "report_date": null,
                    "code_info": null,
                    "more_code_info": null
                }
            ]
        }
        """
        
        let jsonData = jsonString.data(using: .utf8)!
        
        // When
        let response = try JSONDecoder().decode(FDARecallResponse.self, from: jsonData)
        
        // Then
        XCTAssertEqual(response.results.count, 1)
        
        let recall = response.results[0]
        XCTAssertEqual(recall.recallNumber, "F-2024-001")
        XCTAssertNil(recall.status)
        XCTAssertNil(recall.city)
        XCTAssertNil(recall.state)
        XCTAssertNil(recall.country)
        XCTAssertNil(recall.classification)
        XCTAssertNil(recall.productType)
        XCTAssertNil(recall.eventId)
        XCTAssertNil(recall.recallingFirm)
        XCTAssertNil(recall.address1)
        XCTAssertNil(recall.address2)
        XCTAssertNil(recall.postalCode)
        XCTAssertNil(recall.voluntaryMandated)
        XCTAssertNil(recall.initialFirmNotification)
        XCTAssertNil(recall.distributionPattern)
        XCTAssertNil(recall.productDescription)
        XCTAssertNil(recall.productQuantity)
        XCTAssertNil(recall.reasonForRecall)
        XCTAssertNil(recall.recallInitiationDate)
        XCTAssertNil(recall.centerClassificationDate)
        XCTAssertNil(recall.terminationDate)
        XCTAssertNil(recall.reportDate)
        XCTAssertNil(recall.codeInfo)
        XCTAssertNil(recall.moreCodeInfo)
    }
    
    func testFDARecallResponseDecodingWithEmptyResults() throws {
        // Given
        let jsonString = """
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
        
        let jsonData = jsonString.data(using: .utf8)!
        
        // When
        let response = try JSONDecoder().decode(FDARecallResponse.self, from: jsonData)
        
        // Then
        XCTAssertEqual(response.results.count, 0)
        XCTAssertEqual(response.meta.results.total, 0)
    }
    
    // MARK: - Meta Tests
    
    func testMetaDecoding() throws {
        // Given
        let jsonString = """
        {
            "disclaimer": "Test disclaimer",
            "terms": "Test terms",
            "license": "Test license",
            "last_updated": "2024-01-01",
            "results": {
                "skip": 0,
                "limit": 10,
                "total": 1
            }
        }
        """
        
        let jsonData = jsonString.data(using: .utf8)!
        
        // When
        let meta = try JSONDecoder().decode(Meta.self, from: jsonData)
        
        // Then
        XCTAssertEqual(meta.disclaimer, "Test disclaimer")
        XCTAssertEqual(meta.terms, "Test terms")
        XCTAssertEqual(meta.license, "Test license")
        XCTAssertEqual(meta.lastUpdated, "2024-01-01")
        XCTAssertEqual(meta.results.skip, 0)
        XCTAssertEqual(meta.results.limit, 10)
        XCTAssertEqual(meta.results.total, 1)
    }
    
    // MARK: - MetaResults Tests
    
    func testMetaResultsDecoding() throws {
        // Given
        let jsonString = """
        {
            "skip": 20,
            "limit": 50,
            "total": 100
        }
        """
        
        let jsonData = jsonString.data(using: .utf8)!
        
        // When
        let metaResults = try JSONDecoder().decode(MetaResults.self, from: jsonData)
        
        // Then
        XCTAssertEqual(metaResults.skip, 20)
        XCTAssertEqual(metaResults.limit, 50)
        XCTAssertEqual(metaResults.total, 100)
    }
    
    // MARK: - FdaRecall Tests
    
    func testFdaRecallDecoding() throws {
        // Given
        let jsonString = """
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
        """
        
        let jsonData = jsonString.data(using: .utf8)!
        
        // When
        let recall = try JSONDecoder().decode(FdaRecall.self, from: jsonData)
        
        // Then
        XCTAssertEqual(recall.recallNumber, "F-2024-001")
        XCTAssertEqual(recall.status, "Ongoing")
        XCTAssertEqual(recall.city, "New York")
        XCTAssertEqual(recall.state, "NY")
        XCTAssertEqual(recall.country, "US")
        XCTAssertEqual(recall.classification, "Class I")
        XCTAssertNotNil(recall.openfda)
        XCTAssertEqual(recall.productType, "Food")
        XCTAssertEqual(recall.eventId, "12345")
        XCTAssertEqual(recall.recallingFirm, "Test Company Inc")
        XCTAssertEqual(recall.address1, "123 Main St")
        XCTAssertEqual(recall.address2, "Suite 100")
        XCTAssertEqual(recall.postalCode, "10001")
        XCTAssertEqual(recall.voluntaryMandated, "Voluntary")
        XCTAssertEqual(recall.initialFirmNotification, "2024-01-01")
        XCTAssertEqual(recall.distributionPattern, "Nationwide")
        XCTAssertEqual(recall.productDescription, "Test Product")
        XCTAssertEqual(recall.productQuantity, "1000 units")
        XCTAssertEqual(recall.reasonForRecall, "Potential contamination")
        XCTAssertEqual(recall.recallInitiationDate, "20240101")
        XCTAssertEqual(recall.centerClassificationDate, "20240102")
        XCTAssertEqual(recall.terminationDate, "20240215")
        XCTAssertEqual(recall.reportDate, "20240103")
        XCTAssertEqual(recall.codeInfo, "Code info")
        XCTAssertEqual(recall.moreCodeInfo, "More code info")
    }
    
    func testFdaRecallDecodingWithMinimalData() throws {
        // Given
        let jsonString = """
        {
            "recall_number": "F-2024-001"
        }
        """
        
        let jsonData = jsonString.data(using: .utf8)!
        
        // When
        let recall = try JSONDecoder().decode(FdaRecall.self, from: jsonData)
        
        // Then
        XCTAssertEqual(recall.recallNumber, "F-2024-001")
        XCTAssertNil(recall.status)
        XCTAssertNil(recall.city)
        XCTAssertNil(recall.state)
        XCTAssertNil(recall.country)
        XCTAssertNil(recall.classification)
        XCTAssertNil(recall.openfda)
        XCTAssertNil(recall.productType)
        XCTAssertNil(recall.eventId)
        XCTAssertNil(recall.recallingFirm)
        XCTAssertNil(recall.address1)
        XCTAssertNil(recall.address2)
        XCTAssertNil(recall.postalCode)
        XCTAssertNil(recall.voluntaryMandated)
        XCTAssertNil(recall.initialFirmNotification)
        XCTAssertNil(recall.distributionPattern)
        XCTAssertNil(recall.productDescription)
        XCTAssertNil(recall.productQuantity)
        XCTAssertNil(recall.reasonForRecall)
        XCTAssertNil(recall.recallInitiationDate)
        XCTAssertNil(recall.centerClassificationDate)
        XCTAssertNil(recall.terminationDate)
        XCTAssertNil(recall.reportDate)
        XCTAssertNil(recall.codeInfo)
        XCTAssertNil(recall.moreCodeInfo)
    }
    
    // MARK: - OpenFDA Tests
    
    func testOpenFDADecoding() throws {
        // Given
        let jsonString = """
        {}
        """
        
        let jsonData = jsonString.data(using: .utf8)!
        
        // When
        let openFDA = try JSONDecoder().decode(OpenFDA.self, from: jsonData)
        
        // Then
        XCTAssertNotNil(openFDA)
    }
    
    func testOpenFDADecodingWithNull() throws {
        // Given
        let jsonString = """
        null
        """
        
        let jsonData = jsonString.data(using: .utf8)!
        
        // When
        let openFDA = try JSONDecoder().decode(OpenFDA?.self, from: jsonData)
        
        // Then
        XCTAssertNil(openFDA)
    }
    
    // MARK: - Encoding Tests
    
    func testFDARecallResponseEncoding() throws {
        // Given
        let response = FDARecallResponse(
            meta: Meta(
                disclaimer: "Test disclaimer",
                terms: "Test terms",
                license: "Test license",
                lastUpdated: "2024-01-01",
                results: MetaResults(skip: 0, limit: 10, total: 1)
            ),
            results: [
                FdaRecall(
                    recallNumber: "F-2024-001",
                    status: "Ongoing",
                    city: "New York",
                    state: "NY",
                    country: "US",
                    classification: "Class I",
                    openfda: OpenFDA(),
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
            ]
        )
        
        // When
        let jsonData = try JSONEncoder().encode(response)
        let decodedResponse = try JSONDecoder().decode(FDARecallResponse.self, from: jsonData)
        
        // Then
        XCTAssertEqual(decodedResponse.meta.disclaimer, response.meta.disclaimer)
        XCTAssertEqual(decodedResponse.results.count, response.results.count)
        XCTAssertEqual(decodedResponse.results[0].recallNumber, response.results[0].recallNumber)
    }
    
    // MARK: - Edge Cases
    
    func testDecodingWithMissingRequiredFields() {
        // Given
        let jsonString = """
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
        
        let jsonData = jsonString.data(using: .utf8)!
        
        // When & Then
        XCTAssertThrowsError(try JSONDecoder().decode(FDARecallResponse.self, from: jsonData)) { error in
            XCTAssertTrue(error is DecodingError)
        }
    }
}
