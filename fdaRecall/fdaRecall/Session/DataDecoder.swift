//
//  DataDecoder.swift
//
//  Created by banie setijoso
//

import Foundation

class DataDecoder {
    func decode<T>(_ data: Data, with decoder: JSONDecoder) -> Result<(T, Data), DataError> where T: Decodable {
        do {
            let decodedResult = try decoder.decode(T.self, from: data)
            return .success((decodedResult, data))
        } catch let DecodingError.dataCorrupted(context) {
            return .failure(.parsingError(errorMessage: context.debugDescription, dataInString: String(decoding: data, as: UTF8.self)))
        } catch let DecodingError.keyNotFound(key, context) {
            return .failure(.parsingError(errorMessage: "Key '\(key)' not found: \(context.debugDescription)", dataInString: String(decoding: data, as: UTF8.self)))
        } catch let DecodingError.valueNotFound(value, context) {
            return .failure(.parsingError(errorMessage: "Value '\(value)' not found: \(context.debugDescription)", dataInString: String(decoding: data, as: UTF8.self)))
        } catch let DecodingError.typeMismatch(type, context) {
            return .failure(.parsingError(errorMessage: "Type '\(type)' not found: \(context.debugDescription)", dataInString: String(decoding: data, as: UTF8.self)))
        } catch {
            return .failure(.parsingError(errorMessage: error.localizedDescription, dataInString: String(decoding: data, as: UTF8.self)))
        }
    }
}
