import Foundation

// MARK: - FDA Recall Response
struct FDARecallResponse: Codable {
    let meta: Meta
    let results: [FdaRecall]
}

// MARK: - Meta
struct Meta: Codable {
    let disclaimer: String
    let terms: String
    let license: String
    let lastUpdated: String
    let results: MetaResults

    enum CodingKeys: String, CodingKey {
        case disclaimer, terms, license
        case lastUpdated = "last_updated"
        case results
    }
}

// MARK: - Meta Results
struct MetaResults: Codable {
    let skip: Int
    let limit: Int
    let total: Int
}

// MARK: - FdaRecall
struct FdaRecall: Codable {
    let recallNumber: String
    let status: String?
    let city: String?
    let state: String?
    let country: String?
    let classification: String?
    let openfda: OpenFDA?
    let productType: String?
    let eventId: String?
    let recallingFirm: String?
    let address1: String?
    let address2: String?
    let postalCode: String?
    let voluntaryMandated: String?
    let initialFirmNotification: String?
    let distributionPattern: String?
    let productDescription: String?
    let productQuantity: String?
    let reasonForRecall: String?
    let recallInitiationDate: String?
    let centerClassificationDate: String?
    let terminationDate: String?
    let reportDate: String?
    let codeInfo: String?
    let moreCodeInfo: String?

    enum CodingKeys: String, CodingKey {
        case status, city, state, country, classification, openfda
        case productType = "product_type"
        case eventId = "event_id"
        case recallingFirm = "recalling_firm"
        case address1 = "address_1"
        case address2 = "address_2"
        case postalCode = "postal_code"
        case voluntaryMandated = "voluntary_mandated"
        case initialFirmNotification = "initial_firm_notification"
        case distributionPattern = "distribution_pattern"
        case recallNumber = "recall_number"
        case productDescription = "product_description"
        case productQuantity = "product_quantity"
        case reasonForRecall = "reason_for_recall"
        case recallInitiationDate = "recall_initiation_date"
        case centerClassificationDate = "center_classification_date"
        case terminationDate = "termination_date"
        case reportDate = "report_date"
        case codeInfo = "code_info"
        case moreCodeInfo = "more_code_info"
    }
}

// MARK: - OpenFDA
struct OpenFDA: Codable {
    // Empty struct to match the JSON structure
    // Add properties here if the API returns any OpenFDA data
}
