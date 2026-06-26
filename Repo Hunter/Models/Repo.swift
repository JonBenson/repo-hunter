//
//  Repo.swift
//  Repo Hunter
//
//  Created by John Benson on 19/06/2026.
//

nonisolated struct Repos: Sendable, Decodable {
    let items: [Repo]
}

nonisolated struct Repo: Sendable, Decodable {
    let id: Int
    let name: String
    let fullName: String
    let description: String?
    let stargazersCount: Int
    let forksCount: Int
    let htmlURL: String
    let owner: Owner
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case fullName = "full_name"
        case description = "description"
        case stargazersCount = "stargazers_count"
        case forksCount = "forks_count"
        case htmlURL = "html_url"
        case owner = "owner"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.fullName = try container.decode(String.self, forKey: .fullName)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.stargazersCount = try container.decode(Int.self, forKey: .stargazersCount)
        self.forksCount = try container.decode(Int.self, forKey: .forksCount)
        self.htmlURL = try container.decode(String.self, forKey: .htmlURL)
        self.owner = try container.decode(Owner.self, forKey: .owner)
    }
     
    init(
        id: Int,
        name: String,
        fullName: String,
        description: String?,
        stargazersCount: Int,
        forksCount: Int,
        htmlURL: String,
        owner: Owner
    ) {
        self.id = id
        self.name = name
        self.fullName = fullName
        self.description = description
        self.stargazersCount = stargazersCount
        self.forksCount = forksCount
        self.htmlURL = htmlURL
        self.owner = owner
    }
}

nonisolated struct Owner: Sendable, Decodable {
    let id: Int
    let login: String
    let avatarUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case login = "login"
        case avatarUrl = "avatar_url"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.login = try container.decode(String.self, forKey: .login)
        self.avatarUrl = try container.decode(String.self, forKey: .avatarUrl)
    }
    
    init(id: Int, login: String, avatarUrl: String) {
        self.id = id
        self.login = login
        self.avatarUrl = avatarUrl
    }
}
