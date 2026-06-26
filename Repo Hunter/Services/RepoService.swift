//
//  RepoService.swift
//  Repo Hunter
//
//  Created by John Benson on 19/06/2026.
//

import Foundation

enum RepoServiceError: Error {
    case invalidQueryEncoding
}

protocol RepoServiceProtocol {
    func fetchRepos(query: String, page: Int) async throws -> Repos
}

final class RepoService: RepoServiceProtocol {
    
    private let networkClient: NetworkClientProtocol
    
    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }
    
    func fetchRepos(query: String, page: Int) async throws -> Repos {
        guard let escapedQ = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { throw RepoServiceError.invalidQueryEncoding }
       
        return try await networkClient.request(endpoint: "repositories?q=\(escapedQ)&page=\(page)") as Repos
        
    }
    
}

