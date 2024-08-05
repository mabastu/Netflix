//
//  APICaller.swift
//  Netflix
//
//  Created by Mabast on 2024-08-05.
//

import Foundation

struct Constants {
    static let API_KEY = "1737b8007224ab2024a782229bfc4303"
    static let baseURL = "https://api.themoviedb.org"
}

enum APIError {
    case failedToGetData
}

class APICaller {
    static let shared = APICaller()
    
    func getTrendingMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/all/day?api_key=\(Constants.API_KEY)") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let result = try JSONDecoder().decode(TrendingMovies.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
