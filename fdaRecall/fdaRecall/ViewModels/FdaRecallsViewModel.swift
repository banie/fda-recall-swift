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
    @Published var isLoadingMore = false
    @Published var hasMoreData = true
    
    private let repository: FdaRecallsRepository
    private var currentPage = 0
    
    init(repository: FdaRecallsRepository) {
        self.repository = repository
    }
    
    func refresh() {
        isLoading = true
        currentPage = 0
        hasMoreData = true
        
        Task {
            switch await repository.fetch(page: 0) {
            case .success(let page):
                isLoading = false
                hasMoreData = page.hasMoreData
            case .failure(let error):
                isLoading = false
                print("Error: \(error)")
            }
        }
    }
    
    func loadMore(from number: Int = 0) {
        guard !isLoadingMore && hasMoreData else { return }
        
        isLoadingMore = true
        currentPage = number/repository.fetchLimit
        
        Task {
            switch await repository.fetch(page: currentPage) {
            case .success(let page):
                isLoadingMore = false
                hasMoreData = page.hasMoreData
            case .failure(let error):
                isLoadingMore = false
                currentPage -= 1 // Revert page increment on failure
                print("Error loading more: \(error)")
            }
        }
    }
}
