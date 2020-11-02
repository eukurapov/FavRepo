//
//  User.swift
//  FavRepo
//
//  Created by Eugene Kurapov on 02.11.2020.
//

import Foundation

struct User: Codable {
    
    var id: Int
    var login: String
    var name: String?
    var email: String?
    
}
