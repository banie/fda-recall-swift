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
    @Published var errorStatus: String? = nil
    
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
                handleSuccess(page)
            case .failure(let error):
                handleError(error)
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
                handleSuccess(page)
            case .failure(let error):
                currentPage -= 1 // Revert page increment on failure
                handleError(error)
            }
        }
    }
    
    private func handleSuccess(_ page: FdaRecallsPage) {
        isLoading = false
        isLoadingMore = false
        errorStatus = nil
        hasMoreData = page.hasMoreData
    }
    
    private func handleError(_ error: DataError) {
        isLoading = false
        isLoadingMore = false
        
        switch error {
        case .urlIsInvalid:
            errorStatus = "There's an error in our network address, please report it to us"
        case .httpError(status: let status, errorMessage: let errorMessage):
            errorStatus = "There's an error in our network, http status: \(status), \(errorMessage)"
        case .parsingError(errorMessage: let errorMessage, dataInString: _):
            errorStatus = "There's an error in our data parsing: \(errorMessage)"
        case .sessionError(errorMessage: let errorMessage):
            errorStatus = "There's an error in our network: \(errorMessage) Please try again later"
        case .savingError:
            errorStatus = "There's an error in our configuration, please report it to us"
        }
    }
}
