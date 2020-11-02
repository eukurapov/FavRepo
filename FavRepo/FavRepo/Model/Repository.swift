//
//  Repository.swift
//  FavRepo
//
//  Created by Eugene Kurapov on 30.10.2020.
//

import Foundation

struct Repository: Codable, Hashable {
     
    var id: Int
    var fullName: String
    var description: String?
    var owner: User
    
    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case description
        case owner
    }
    
}

extension Repository: Equatable {
    
    static func == (lhs: Repository, rhs: Repository) -> Bool {
        lhs.id == rhs.id
    }
    
}

extension Repository {
    
    var isFavorite: Bool {
        return RepositoryService.shared.favorites.contains(self)
    }
    
    func toggleIsFavorite() {
        if !isFavorite {
            RepositoryService.shared.likeRepository(self)
        } else {
            RepositoryService.shared.unlikeRepository(self)
        }
    }
    
}
