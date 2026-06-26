//
//  SearchViewModel.swift
//  Repo Hunter
//
//  Created by John Benson on 19/06/2026.
//

import Foundation
import Combine
import UIKit


extension SearchViewController {
    
    @MainActor
    class ViewModel: ObservableObject{
        
        @Published var searchText = ""
        @Published private(set) var repos: [Repo] = []
        
        private let repoService: RepoServiceProtocol
        private var cancellables = Set<AnyCancellable>()
        private var currentPage = 1
        
        
        init(repoService: RepoServiceProtocol) {
            self.repoService = repoService
            bindSearchText()
        }
        
        private func bindSearchText() {
            $searchText
                .debounce(
                    for: .milliseconds(500),
                    scheduler: DispatchQueue.main
                )
                .removeDuplicates()
                .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
                .sink { [weak self] query in
                    Task{
                        self?.currentPage = 1
                        let results = try await self?.repoService.fetchRepos(query: query, page: 1)
                        if let items = results?.items {
                            self?.repos = items
                        }
                    }
                }
                .store(in: &cancellables)
            
        }
        
        func loadNextPage() async {
            do {
                currentPage += 1
                let nextResults = try await repoService.fetchRepos(query: searchText, page: currentPage)
                repos.append(contentsOf: nextResults.items)
            }catch{
                print("Could not get results")
                currentPage -= 1
            }
            
        }
        
    }
}
