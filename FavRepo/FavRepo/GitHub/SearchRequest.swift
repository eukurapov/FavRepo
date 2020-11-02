//
//  SearchProvider.swift
//  FavRepo
//
//  Created by Eugene Kurapov on 30.10.2020.
//

import Foundation

struct SearchResult: Codable {
    var items: [Repository]
}

enum SearchError: Error {
    case parsing
    case server
    case unknown
}

class SearchRequest {
    
    var query: String
    var result = [Repository]()
    
    private var dataTask: URLSessionDataTask?
    
    init(for query: String) {
        self.query = query
    }
    
    func fetch(completion: @escaping (Result<[Repository], Error>) -> Void) {
        dataTask?.cancel()
        
        guard let url = URL(string: "https://api.github.com/search/repositories?q=\(query)&order=desc") else { return }
        
        dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            defer {
                self?.dataTask = nil
            }
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
                    let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
                    self?.result.append(contentsOf: searchResult.items)
                    DispatchQueue.main.async {
                        completion(Result.success(searchResult.items))
                    }
                    return
                } catch {
                    print(error)
                    completion(Result.failure(SearchError.parsing))
                    return
                }
            }
            completion(Result.failure(SearchError.unknown))
            return
        }
        dataTask?.resume()
    }
    
}
