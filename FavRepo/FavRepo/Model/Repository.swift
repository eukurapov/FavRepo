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
    var owner: Owner
    var isFavorite: Bool = false
    
    struct Owner: Codable {
        var id: Int
        var login: String
        var name: String?
        var email: String?
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case description
        case owner
    }
    
}
