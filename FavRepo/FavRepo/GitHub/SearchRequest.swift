//
//  SearchProvider.swift
//  FavRepo
//
//  Created by Eugene Kurapov on 30.10.2020.
//

import Foundation

struct SearchResult: Codable {
    var total: Int
    var items: [Repository]
    
    enum CodingKeys: String, CodingKey {
        case total = "total_count"
        case items
    }
}

enum SearchError: Error {
    case badRequest
    case parsing
    case server
    case unknown
}

class SearchRequest {
    
    var query: String
    var result = [Repository]()
    var isFullyLoaded: Bool {
        return result.count == total
    }
    
    var total = 0
    private var loadedPages = 0
    
    private var dataTask: URLSessionDataTask?
    
    init(for query: String) {
        self.query = query
    }
    
    func fetch(completion: @escaping (Result<[Repository], Error>) -> Void) {
        dataTask?.cancel()
        
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://api.github.com/search/repositories?q=\(encodedQuery)&order=desc&page=\(loadedPages+1)") else {
            completion(Result.failure(SearchError.badRequest))
            return
        }
        
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
                    self?.loadedPages += 1
                    self?.total = searchResult.total
                    DispatchQueue.main.async {
                        completion(Result.success(searchResult.items))
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
        dataTask?.resume()
    }
    
}
