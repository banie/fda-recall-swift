//
//  FdaRecallData.swift
//  fdaRecall
//
//  Created by banie setijoso on 2025-10-10.
//

import Foundation
import SwiftData

@Model
class FdaRecallData {
    @Attribute(.unique) var recallNumber: String
    var status: String?
    var city: String?
    var state: String?
    var country: String?
    var classification: String?
    var productType: String?
    var eventId: String?
    var recallingFirm: String?
    var address1: String?
    var address2: String?
    var postalCode: String?
    var voluntaryMandated: String?
    var initialFirmNotification: String?
    var distributionPattern: String?
    var productDescription: String?
    var productQuantity: String?
    var reasonForRecall: String?
    var recallInitiationDate: String?
    var centerClassificationDate: String?
    var terminationDate: String?
    var reportDate: String?
    var codeInfo: String?
    var moreCodeInfo: String?
    
    init(recallNumber: String,
         status: String? = nil,
         city: String? = nil,
         state: String? = nil,
         country: String? = nil,
         classification: String? = nil,
         productType: String? = nil,
         eventId: String? = nil,
         recallingFirm: String? = nil,
         address1: String? = nil,
         address2: String? = nil,
         postalCode: String? = nil,
         voluntaryMandated: String? = nil,
         initialFirmNotification: String? = nil,
         distributionPattern: String? = nil,
         productDescription: String? = nil,
         productQuantity: String? = nil,
         reasonForRecall: String? = nil,
         recallInitiationDate: String? = nil,
         centerClassificationDate: String? = nil,
         terminationDate: String? = nil,
         reportDate: String? = nil,
         codeInfo: String? = nil,
         moreCodeInfo: String? = nil) {
        self.recallNumber = recallNumber
        self.status = status
        self.city = city
        self.state = state
        self.country = country
        self.classification = classification
        self.productType = productType
        self.eventId = eventId
        self.recallingFirm = recallingFirm
        self.address1 = address1
        self.address2 = address2
        self.postalCode = postalCode
        self.voluntaryMandated = voluntaryMandated
        self.initialFirmNotification = initialFirmNotification
        self.distributionPattern = distributionPattern
        self.productDescription = productDescription
        self.productQuantity = productQuantity
        self.reasonForRecall = reasonForRecall
        self.recallInitiationDate = recallInitiationDate
        self.centerClassificationDate = centerClassificationDate
        self.terminationDate = terminationDate
        self.reportDate = reportDate
        self.codeInfo = codeInfo
        self.moreCodeInfo = moreCodeInfo
    }
    
    // Convenience initializer from FdaRecall struct
    convenience init(from fdaRecall: FdaRecall) {
        self.init(
            recallNumber: fdaRecall.recallNumber,
            status: fdaRecall.status,
            city: fdaRecall.city,
            state: fdaRecall.state,
            country: fdaRecall.country,
            classification: fdaRecall.classification,
            productType: fdaRecall.productType,
            eventId: fdaRecall.eventId,
            recallingFirm: fdaRecall.recallingFirm,
            address1: fdaRecall.address1,
            address2: fdaRecall.address2,
            postalCode: fdaRecall.postalCode,
            voluntaryMandated: fdaRecall.voluntaryMandated,
            initialFirmNotification: fdaRecall.initialFirmNotification,
            distributionPattern: fdaRecall.distributionPattern,
            productDescription: fdaRecall.productDescription,
            productQuantity: fdaRecall.productQuantity,
            reasonForRecall: fdaRecall.reasonForRecall,
            recallInitiationDate: fdaRecall.recallInitiationDate,
            centerClassificationDate: fdaRecall.centerClassificationDate,
            terminationDate: fdaRecall.terminationDate,
            reportDate: fdaRecall.reportDate,
            codeInfo: fdaRecall.codeInfo,
            moreCodeInfo: fdaRecall.moreCodeInfo
        )
    }
}

// MARK: - Computed Properties for Display
extension FdaRecallData {
    var displayTitle: String {
        return productDescription ?? recallingFirm ?? "Unknown Recall"
    }
    
    var displaySubtitle: String {
        var components: [String] = []
        
        if let firm = recallingFirm {
            components.append(firm)
        }
        
        if let city = city, let state = state {
            components.append("\(city), \(state)")
        } else if let state = state {
            components.append(state)
        }
        
        return components.joined(separator: " • ")
    }
    
    var recallDate: Date? {
        guard let dateString = recallInitiationDate else { return nil }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter.date(from: dateString)
    }
    
    var formattedRecallDate: String {
        guard let date = recallDate else { return "Unknown Date" }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
