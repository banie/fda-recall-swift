//
//  GetFdaRecalls.swift
//  fdaRecall
//
//  Created by banie setijoso on 2025-10-13.
//

protocol GetFdaRecalls {
    func fetch(skip: Int?, limit: Int?) async -> Result<[FdaRecall], DataError>
}

class GetFdaRecallsImpl: GetFdaRecalls {
    private let httpSession: HttpSession
    
    init(httpSession: HttpSession) {
        self.httpSession = httpSession
    }
    
    func fetch(skip: Int? = 0, limit: Int? = 0) async -> Result<[FdaRecall], DataError> {
        var parameters: [String: Any] = [:]
        if let skip = skip {
            parameters["skip"] = skip
        }
        if let limit = limit {
            parameters["limit"] = limit
        }
        // Sort by recall initiation date in descending order (most recent first)
        parameters["sort"] = "recall_initiation_date:desc"
        
        switch await httpSession.get(parameters: parameters) as Result<FDARecallResponse, DataError> {
        case .success(let response):
            return .success(response.results)
        case .failure(let error):
            return .failure(error)
        }
    }
}
