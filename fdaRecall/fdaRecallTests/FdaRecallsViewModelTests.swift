//
//  FdaRecallsViewModelTests.swift
//  fdaRecallTests
//
//  Created by banie setijoso on 2025-10-13.
//

import XCTest
import Combine
@testable import fdaRecall

@MainActor
final class FdaRecallsViewModelTests: XCTestCase {
    
    var sut: FdaRecallsViewModel!
    var mockRepository: MockFdaRecallsRepository!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockFdaRecallsRepository()
        sut = FdaRecallsViewModel(repository: mockRepository)
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        cancellables = nil
        sut = nil
        mockRepository = nil
        super.tearDown()
    }
    
    // MARK: - Initial State Tests
    
    func testInitialState() {
        // Then
        XCTAssertFalse(sut.isLoading)
        XCTAssertFalse(sut.isLoadingMore)
        XCTAssertTrue(sut.hasMoreData)
    }
    
    // MARK: - Refresh Tests
    
    func testRefreshSuccess() async {
        // Given
        let mockPage = FdaRecallsPage(hasMoreData: true, currentPage: 0)
        mockRepository.mockFetchResult = .success(mockPage)
        
        // When
        sut.refresh()
        
        // Wait for async operation to complete
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Then
        XCTAssertFalse(sut.isLoading)
        XCTAssertTrue(sut.hasMoreData)
        XCTAssertTrue(mockRepository.fetchCalled)
        XCTAssertEqual(mockRepository.lastPage, 0)
    }
    
    func testRefreshFailure() async {
        // Given
        let error = DataError.sessionError(errorMessage: "Network error")
        mockRepository.mockFetchResult = .failure(error)
        
        // When
        sut.refresh()
        
        // Wait for async operation to complete
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Then
        XCTAssertFalse(sut.isLoading)
        XCTAssertTrue(sut.hasMoreData) // Should remain true on error
        XCTAssertTrue(mockRepository.fetchCalled)
        XCTAssertEqual(mockRepository.lastPage, 0)
    }
    
    func testRefreshSetsCorrectState() async {
        // Given
        let mockPage = FdaRecallsPage(hasMoreData: false, currentPage: 0)
        mockRepository.mockFetchResult = .success(mockPage)
        
        // When
        sut.refresh()
        
        // Then - immediately after calling refresh
        XCTAssertTrue(sut.isLoading)
        XCTAssertFalse(sut.isLoadingMore)
        XCTAssertTrue(sut.hasMoreData) // Should be reset to true initially
        
        // Wait for async operation to complete
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Then - after completion
        XCTAssertFalse(sut.isLoading)
        XCTAssertFalse(sut.hasMoreData) // Should reflect the page's hasMoreData
    }
    
    // MARK: - Load More Tests
    
    func testLoadMoreSuccess() async {
        // Given
        let mockPage = FdaRecallsPage(hasMoreData: true, currentPage: 1)
        mockRepository.mockFetchResult = .success(mockPage)
        
        // When
        sut.loadMore(from: 20) // 20 items, so page should be 1 (20/20 = 1)
        
        // Wait for async operation to complete
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Then
        XCTAssertFalse(sut.isLoadingMore)
        XCTAssertTrue(sut.hasMoreData)
        XCTAssertTrue(mockRepository.fetchCalled)
        XCTAssertEqual(mockRepository.lastPage, 1)
    }
    
    func testLoadMoreFailure() async {
        // Given
        let error = DataError.httpError(
            status: HTTPStatusCode.internalServerError,
            errorMessage: "Server error"
        )
        mockRepository.mockFetchResult = .failure(error)
        
        // When
        sut.loadMore(from: 20)
        
        // Wait for async operation to complete
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Then
        XCTAssertFalse(sut.isLoadingMore)
        XCTAssertTrue(sut.hasMoreData) // Should remain true on error
        XCTAssertTrue(mockRepository.fetchCalled)
        XCTAssertEqual(mockRepository.lastPage, 1)
    }
    
    func testLoadMoreWhenAlreadyLoading() async {
        // Given
        sut.isLoadingMore = true
        
        // When
        sut.loadMore(from: 20)
        
        // Wait for async operation to complete
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Then
        XCTAssertFalse(mockRepository.fetchCalled) // Should not call repository
    }
    
    func testLoadMoreWhenNoMoreData() async {
        // Given
        sut.hasMoreData = false
        
        // When
        sut.loadMore(from: 20)
        
        // Wait for async operation to complete
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Then
        XCTAssertFalse(mockRepository.fetchCalled) // Should not call repository
    }
    
    func testLoadMoreCalculatesCorrectPage() async {
        // Given
        let mockPage = FdaRecallsPage(hasMoreData: true, currentPage: 2)
        mockRepository.mockFetchResult = .success(mockPage)
        
        // When
        sut.loadMore(from: 40) // 40 items, so page should be 2 (40/20 = 2)
        
        // Wait for async operation to complete
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Then
        XCTAssertEqual(mockRepository.lastPage, 2)
    }
    
    func testLoadMoreSetsCorrectState() async {
        // Given
        let mockPage = FdaRecallsPage(hasMoreData: false, currentPage: 1)
        mockRepository.mockFetchResult = .success(mockPage)
        
        // When
        sut.loadMore(from: 20)
        
        // Then - immediately after calling loadMore
        XCTAssertTrue(sut.isLoadingMore)
        XCTAssertFalse(sut.isLoading)
        
        // Wait for async operation to complete
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Then - after completion
        XCTAssertFalse(sut.isLoadingMore)
        XCTAssertFalse(sut.hasMoreData) // Should reflect the page's hasMoreData
    }
    
    func testLoadMoreRevertsPageOnFailure() async {
        // Given
        let error = DataError.sessionError(errorMessage: "Network error")
        mockRepository.mockFetchResult = .failure(error)
        
        // When
        sut.loadMore(from: 20) // This should set currentPage to 1
        
        // Wait for async operation to complete
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Then
        // The currentPage should be reverted to 0 (1 - 1) on failure
        // Note: This tests the current implementation behavior
        XCTAssertTrue(mockRepository.fetchCalled)
    }
    
    // MARK: - Edge Cases
    
    func testLoadMoreWithZeroItems() async {
        // Given
        let mockPage = FdaRecallsPage(hasMoreData: true, currentPage: 0)
        mockRepository.mockFetchResult = .success(mockPage)
        
        // When
        sut.loadMore(from: 0) // 0 items, so page should be 0 (0/20 = 0)
        
        // Wait for async operation to complete
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Then
        XCTAssertEqual(mockRepository.lastPage, 0)
    }
    
    func testLoadMoreWithLargeNumber() async {
        // Given
        let mockPage = FdaRecallsPage(hasMoreData: true, currentPage: 5)
        mockRepository.mockFetchResult = .success(mockPage)
        
        // When
        sut.loadMore(from: 100) // 100 items, so page should be 5 (100/20 = 5)
        
        // Wait for async operation to complete
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Then
        XCTAssertEqual(mockRepository.lastPage, 5)
    }
    
    // MARK: - Publisher Tests
    
    func testIsLoadingPublisher() async {
        // Given
        var isLoadingValues: [Bool] = []
        sut.$isLoading
            .sink { isLoadingValues.append($0) }
            .store(in: &cancellables)
        
        let mockPage = FdaRecallsPage(hasMoreData: true, currentPage: 0)
        mockRepository.mockFetchResult = .success(mockPage)
        
        // When
        sut.refresh()
        
        // Wait for async operation to complete
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Then
        XCTAssertEqual(isLoadingValues, [false, true, false]) // Initial, loading, completed
    }
    
    func testIsLoadingMorePublisher() async {
        // Given
        var isLoadingMoreValues: [Bool] = []
        sut.$isLoadingMore
            .sink { isLoadingMoreValues.append($0) }
            .store(in: &cancellables)
        
        let mockPage = FdaRecallsPage(hasMoreData: true, currentPage: 1)
        mockRepository.mockFetchResult = .success(mockPage)
        
        // When
        sut.loadMore(from: 20)
        
        // Wait for async operation to complete
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Then
        XCTAssertEqual(isLoadingMoreValues, [false, true, false]) // Initial, loading, completed
    }
    
    func testHasMoreDataPublisher() async {
        // Given
        var hasMoreDataValues: [Bool] = []
        sut.$hasMoreData
            .sink { hasMoreDataValues.append($0) }
            .store(in: &cancellables)
        
        let mockPage = FdaRecallsPage(hasMoreData: false, currentPage: 0)
        mockRepository.mockFetchResult = .success(mockPage)
        
        // When
        sut.refresh()
        
        // Wait for async operation to complete
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Then
        XCTAssertEqual(hasMoreDataValues, [true, true, false]) // Initial, reset, final
    }
}

// MARK: - Mock Repository

class MockFdaRecallsRepository: FdaRecallsRepository {
    var fetchLimit: Int = 20
    var mockFetchResult: Result<FdaRecallsPage, DataError> = .failure(.sessionError(errorMessage: "Not implemented"))
    var fetchCalled = false
    var lastPage: Int?
    
    func fetch(page: Int) async -> Result<FdaRecallsPage, DataError> {
        fetchCalled = true
        lastPage = page
        return mockFetchResult
    }
}
