//
//  Repository.swift
//  FavRepo
//
//  Created by Eugene Kurapov on 30.10.2020.
//

import Foundation

struct Repository: Codable {
    
    var id: Int
    var fullName: String
    var description: String?
    var owner: User
    var isFavorite: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case description
        case owner
    }
    
}
