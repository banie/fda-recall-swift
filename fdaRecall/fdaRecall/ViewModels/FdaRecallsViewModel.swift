//
//  FdaRecallsViewModel.swift
//  fdaRecall
//
//  Created by banie setijoso on 2025-10-12.
//

import Foundation
import Combine

class FdaRecallsViewModel: ObservableObject {
    @Published var recalls: [FdaRecall] = []
    
    func refresh() {
        Task {
            guard let session = HttpSession(apiKey: "", fullUrlPath: "https://api.fda.gov/food/enforcement.json") else {
                print("Failed to create session")
                return
            }

            switch await session.get() as Result<FDARecallResponse, DataError> {
            case .success(let response):
                await MainActor.run {
                    self.recalls = response.results
                    print("recalls: \(self.recalls)")
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}
