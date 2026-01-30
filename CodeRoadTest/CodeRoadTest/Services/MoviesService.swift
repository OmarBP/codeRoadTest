//
//  MoviesService.swift
//  CodeRoadTest
//
//  Created by Omar Barrera Peña on 30/01/26.
//

import Foundation

protocol APIService {
    func getList(_ response: @escaping (Result<SearchData, Error>) -> Void)
}

class MoviesService: APIService {
    let baseURL = "https://www.omdbapi.com/?"
    let apiKey = "7be98d2c"
    
    func getList(_ result: @escaping (Result<SearchData, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)s=Batman&apikey=\(apiKey)") else {
            result(.failure(APIError.invalidURL))
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                result(.failure(error))
            }
            if let response = response as? HTTPURLResponse, !(200 ..< 300).contains(response.statusCode) {
                result(.failure(APIError.invalidRequest))
                return
            }
            guard let data = data else {
                result(.failure(APIError.noData))
                return
            }
            do {
                let searchData = try JSONDecoder().decode(SearchData.self, from: data)
                result(.success(searchData))
            } catch {
                result(.failure(APIError.invalidData))
            }
        }
        task.resume()
    }
}

enum APIError: Error {
    case invalidURL
    case invalidRequest
    case noData
    case invalidData
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .invalidURL:
                return "The URL is not valid"
            case .invalidRequest:
                return "The request was invalid"
            case .noData:
                return "The is no data in the response"
            case .invalidData:
                return "The data is not valid"
        }
    }
}
