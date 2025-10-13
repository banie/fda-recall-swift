//
//  FdaRecallsViewModel.swift
//  fdaRecall
//
//  Created by banie setijoso on 2025-10-12.
//

import Foundation
import Combine

@MainActor
class FdaRecallsViewModel: ObservableObject {
    @Published var isLoading = false
    
    private let repository: FdaRecallsRepository
    
    init(repository: FdaRecallsRepository) {
        self.repository = repository
    }
    
    func refresh() {
        isLoading = true
        Task {
            switch await repository.fetch(page: 0) {
            case .success:
                isLoading = false
            case .failure(let error):
                isLoading = false
                print("Error: \(error)")
            }
        }
    }
}
