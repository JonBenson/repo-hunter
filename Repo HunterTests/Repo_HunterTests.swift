//
//  Repo_HunterTests.swift
//  Repo HunterTests
//
//  Created by John Benson on 26/06/2026.
//

import XCTest

@MainActor
final class ViewModelTests: XCTestCase {
    
    var service: MockRepoService!
    var viewModel: SearchViewController.ViewModel!
    
    
    override func setUp() {
        service = MockRepoService()
        viewModel = SearchViewController.ViewModel(repoService: service)
    }
    
    override func tearDown() {
        service = nil
        viewModel = nil
    }
    
    func testSearchFetchesRepos() async throws {
        
        viewModel.searchText = "swift"
        
        // Wait for debounce + async fetch
        try await Task.sleep(for: .milliseconds(700))
        
        XCTAssertTrue(service.fetchReposCalled)
        XCTAssertEqual(service.receivedQuery, "swift")
        XCTAssertEqual(service.receivedPage, 1)
        XCTAssertEqual(viewModel.repos.count, 1)
    }
    
    func testLoadNextPageAppendsResults() async throws {
        let service = MockRepoService()
        let viewModel = SearchViewController.ViewModel(repoService: service)
        
        service.result = Repos(items: [
            Repo(id: 1, name: "Repo 1", fullName: "", description: "", stargazersCount: 1, forksCount: 1, htmlURL: "", owner: Owner(id: 1, login: "", avatarUrl: ""))
        ])
        
        viewModel.searchText = "swift"
        
        try await Task.sleep(for: .milliseconds(700))
        
        service.result = Repos(items: [
            Repo(id: 2, name: "Repo 2", fullName: "", description: "", stargazersCount: 1, forksCount: 1, htmlURL: "", owner: Owner(id: 1, login: "", avatarUrl: ""))
        ])
        
        await viewModel.loadNextPage()
        
        XCTAssertEqual(viewModel.repos.count, 2)
        XCTAssertEqual(viewModel.repos.last?.name, "Repo 2")
    }
}

final class MockRepoService: RepoServiceProtocol {

    var fetchReposCalled = false
    var receivedQuery: String?
    var receivedPage: Int?
    
    var result = Repos( items: [
        Repo(id: 1,
             name: "Repo 1",
             fullName: "",
             description: "",
             stargazersCount: 1,
             forksCount: 1,
             htmlURL: "",
             owner: Owner(
                id: 1,
                login: "",
                avatarUrl: "")
            )
    ])
    
    func fetchRepos(query: String, page: Int) async throws -> Repos {
        fetchReposCalled = true
        receivedQuery = query
        receivedPage = page
        return result
    }
}
