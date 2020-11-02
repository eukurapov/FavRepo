//
//  RepositoryService.swift
//  FavRepo
//
//  Created by Eugene Kurapov on 02.11.2020.
//

import Foundation

class RepositoryService {
    
    static let shared: RepositoryService = {
        let service = RepositoryService()
        service.loadFavorites()
        return service
    }()
    
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
        saveFavorites()
    }
    
    func unlikeRepository(_ repository: Repository) {
        favorites.remove(repository)
        favoritesDelegate?.favoritesList(didChangeStateFor: repository)
        saveFavorites()
    }
    
    private let favoritesFileName: String = "favorites"
    
}

protocol FavoritesDelegate {
    func favoritesList(didChangeStateFor repository: Repository)
}

extension RepositoryService {
    
    var favoritesFileURL: URL {
        let fileManager = FileManager.default
        return fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0].appendingPathComponent("\(favoritesFileName).json")
    }
    
    func loadFavorites(completion: ((Bool) -> Void)? = nil) {
        let url = favoritesFileURL
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let data = try Data(contentsOf: url)
                if let repositories = try? JSONDecoder().decode(Set<Repository>.self, from: data) {
                    self.favorites = repositories
                    DispatchQueue.main.async {
                        completion?(true)
                    }
                    return
                }
            } catch {
                print(error)
            }
            DispatchQueue.main.async {
                completion?(false)
            }
        }
    }
    
    private func saveFavorites() {
        let url = favoritesFileURL
        DispatchQueue.global(qos: .background).async {
            if let data = try? JSONEncoder().encode(self.favorites) {
                do {
                    try data.write(to: url)
                } catch {
                    print(error)
                }
            }
        }
    }
    
}
