//
//  RepositoryService.swift
//  FavRepo
//
//  Created by Eugene Kurapov on 02.11.2020.
//

import Foundation

class RepositoryService {
    
    static let shared = RepositoryService()
    
    private(set) var favorites = Set<Repository>()
    var favoritesDelegate: FavoritesDelegate?
    
    func fetchDetailsForUserLogin(_ login: String, completion: @escaping (Result<User,Error>) -> Void) {
        guard let url = URL(string: "https://api.github.com/users/\(login)") else { return }
        
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(Result.failure(error))
                }
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    completion(Result.failure(SearchError.server))
                }
                return
            }
            if let data = data {
                do {
                    let searchResult = try JSONDecoder().decode(User.self, from: data)
                    DispatchQueue.main.async {
                        completion(Result.success(searchResult))
                    }
                    return
                } catch {
                    DispatchQueue.main.async {
                        completion(Result.failure(SearchError.parsing))
                    }
                    return
                }
            }
            DispatchQueue.main.async {
                completion(Result.failure(SearchError.unknown))
            }
            return
        }
        dataTask.resume()
    }
    
    func likeRepository(_ repository: Repository) {
        favorites.insert(repository)
        favoritesDelegate?.favoritesList(didChangeStateFor: repository)
    }
    
    func unlikeRepository(_ repository: Repository) {
        favorites.remove(repository)
        favoritesDelegate?.favoritesList(didChangeStateFor: repository)
    }
    
}

protocol FavoritesDelegate {
    
    func favoritesList(didChangeStateFor repository: Repository)
    
}
