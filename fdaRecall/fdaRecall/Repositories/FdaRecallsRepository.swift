//
//  FdaRecallsRepository.swift
//  fdaRecall
//
//  Created by banie setijoso on 2025-10-13.
//

import Foundation
import SwiftData
import os.log

protocol FdaRecallsRepository {
    var fetchLimit: Int { get }
    func fetch(page: Int) async -> Result<FdaRecallsPage, DataError>
}

struct FdaRecallsPage {
    let hasMoreData: Bool
    let currentPage: Int
}

class FdaRecallsRepositoryImpl: FdaRecallsRepository {
    let fetchLimit = 20
    private let modelContext: ModelContext
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.banie",
        category: "network"
    )
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func fetch(page: Int = 0) async -> Result<FdaRecallsPage, DataError> {
        guard let httpSession = HttpSession(apiKey: "", fullUrlPath: BASE_URL) else {
            return .failure(.urlIsInvalid)
        }
        
        let skip = page * fetchLimit
        let getFdaRecalls = GetFdaRecallsImpl(httpSession: httpSession)
        
        switch await getFdaRecalls.fetch(skip: skip, limit: fetchLimit) {
        case .success(let fdaRecalls):
            for fdaRecall in fdaRecalls {
                modelContext.insert(FdaRecallData(from: fdaRecall))
            }
            
            do {
                try modelContext.save()
            } catch {
                logger.error("Error saving context: \(error)")
                return .failure(.urlIsInvalid)
            }
            
            // Determine if there's more data based on the number of items returned
            let hasMoreData = fdaRecalls.count == fetchLimit
            return .success(FdaRecallsPage(hasMoreData: hasMoreData, currentPage: page))
        case .failure(let error):
            return .failure(error)
        }
    }
}
