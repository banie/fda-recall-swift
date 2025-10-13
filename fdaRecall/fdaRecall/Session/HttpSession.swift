//
//  HttpSession.swift
//
//  Created by banie setijoso
//

import Foundation
import os.log

class HttpSession {
    private let sessionApi: SessionApi
    private let decoder: JSONDecoder
    private let apiKey: String
    private var urlComponents: URLComponents

    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.banie",
        category: "network"
    )

    init?(apiKey: String, fullUrlPath: String, sessionApi: SessionApi = DataSession()) {
        guard let url = URL(string: fullUrlPath), let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return nil
        }

        self.apiKey = apiKey
        self.urlComponents = urlComponents
        self.sessionApi = sessionApi
        decoder = JSONDecoder()
    }

    func get<T>(parameters: [String: Any] = [:], headers: [String: String] = [:]) async -> Result<T, DataError> where T: Decodable {
        await execute(httpMethod: "GET", parameters: parameters, headers: headers)
    }

    func post<T>(parameters: [String: Any] = [:], headers: [String: String] = [:], body: Encodable? = nil) async -> Result<T, DataError> where T: Decodable {
        return await execute(httpMethod: "POST", parameters: parameters, headers: headers)
    }

    func delete<T>(parameters: [String: Any] = [:], headers: [String: String] = [:]) async -> Result<T, DataError> where T: Decodable {
        await execute(httpMethod: "DELETE", parameters: parameters, headers: headers)
    }

    func put<T>(parameters: [String: Any] = [:], headers: [String: String] = [:], body: Encodable? = nil) async -> Result<T, DataError> where T: Decodable {
        await execute(httpMethod: "PUT", parameters: parameters, headers: headers)
    }

    private func execute<T>(httpMethod: String, parameters: [String: Any] = [:], headers: [String: String] = [:], body: Encodable? = nil) async -> Result<T, DataError> where T: Decodable {
        urlComponents.append(parameters: parameters)

        guard let composedUrl = urlComponents.url else {
            return .failure(.urlIsInvalid)
        }

        var request = URLRequest(url: composedUrl)
        request.decorate(using: makeDefaultHeaders())
        request.httpMethod = httpMethod
        request.decorate(using: headers)

        if let body = body {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .withoutEscapingSlashes
            do {
                let jsonData = try encoder.encode(body)
                request.httpBody = jsonData
            } catch {
                logger.error("Error encoding object: \(error)")
                return .failure(.parsingError(errorMessage: error.localizedDescription, dataInString: ""))
            }
        }

        let sessionResult: (Data, URLResponse)
        do {
            sessionResult = try await sessionApi.data(for: request)
        } catch {
            logger.error("Error sessionError: \(error)")
            return .failure(.sessionError(errorMessage: error.localizedDescription))
        }

        let data = sessionResult.0
        let response = sessionResult.1

        // print("XXXX data: \(String(decoding: data, as: UTF8.self))")
        if let httpResponse = response as? HTTPURLResponse,
            let status = httpResponse.status,
            status.responseType != .success {
            return .failure(.httpError(status: status, errorMessage: status.localizedDescription + " curl: " + request.curlString))
        }

        do {
            let decodedResult = try decoder.decode(T.self, from: sessionResult.0)
            return .success(decodedResult)
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

    func makeDefaultHeaders() -> [String: String] {
        var headers = ["Content-Type": "application/json"]
        headers["Accept"] = "*/*"
        headers["Accept-Encoding"] = "gzip, deflate, br"
        headers["Connection"] = "keep-alive"
        headers["x-api-key"] = apiKey

        return headers
    }
}
