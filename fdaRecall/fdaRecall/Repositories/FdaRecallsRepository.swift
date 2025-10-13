//
//  FdaRecallsRepository.swift
//  fdaRecall
//
//  Created by banie setijoso on 2025-10-13.
//

import SwiftData

protocol FdaRecallsRepository {
    func fetch(page: Int) async -> Result<Void, DataError>
}

class FdaRecallsRepositoryImpl: FdaRecallsRepository {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func fetch(page: Int = 0) async -> Result<Void, DataError> {
        guard let httpSession = HttpSession(apiKey: "", fullUrlPath: BASE_URL) else {
            return .failure(.urlIsInvalid)
        }
        
        let limit = 20
        let skip = page * limit
        let getFdaRecalls = GetFdaRecallsImpl(httpSession: httpSession)
        switch await getFdaRecalls.fetch(skip: skip, limit: limit) {
        case .success(let fdaRecalls):
            for fdaRecall in fdaRecalls {
                modelContext.insert(FdaRecallData(from: fdaRecall))
            }
            return .success(())
        case .failure(let error):
            print("Error: \(error)")
            return .failure(error)
        }
    }
}
