//
//  NetworkError.swift
//
//  Created by banie setijoso
//

import Foundation

enum DataError: Error {
    case urlIsInvalid
    case httpError(status: HTTPStatusCode, errorMessage: String)
    case parsingError(errorMessage: String, dataInString: String)
    case sessionError(errorMessage: String)
}
