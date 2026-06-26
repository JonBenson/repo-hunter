//
//  NetworkClient.swift
//  Repo Hunter
//
//  Created by John Benson on 19/06/2026.
//

import Foundation

protocol NetworkClientProtocol {
    func request<T: Decodable & Sendable>(endpoint: String) async throws -> T
}

final class NetworkClient: NetworkClientProtocol, @unchecked Sendable {
    func request<T>(endpoint: String) async throws -> T where T : Decodable & Sendable {
        guard let url = URL(string: "https://api.github.com/search/\(endpoint)") else { throw URLError(.badURL)}
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
    
}
