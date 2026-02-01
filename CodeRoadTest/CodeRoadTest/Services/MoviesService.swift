//
//  MoviesService.swift
//  CodeRoadTest
//
//  Created by Omar Barrera Peña on 30/01/26.
//

import Foundation

class MoviesService: APIService {
    fileprivate let baseURL = "https://www.omdbapi.com/?"
    fileprivate let apiKey = "7be98d2c"
    
    func getList(title: String, result: @escaping (Result<SearchData, Error>) -> Void) {
        let url = "\(baseURL)s=\(title)&apikey=\(apiKey)"
        performRequest(url: url) { requestResult in
            switch requestResult {
                case .success(let data):
                    do {
                        let searchData = try JSONDecoder().decode(SearchData.self, from: data)
                        result(.success(searchData))
                    } catch {
                        result(.failure(APIError.invalidData))
                    }
                case .failure(let error):
                    result(.failure(error))
            }
        }
    }
    
    func getImage(imageURL: String, result: @escaping (Result<Data, Error>) -> Void) {
        performRequest(url: imageURL) { requestResult in
            result(requestResult)
        }
    }
    
    func getDetails(id: String, result: @escaping (Result<MovieDetailData, Error>) -> Void) {
        let url = "\(baseURL)i=\(id)&apikey=\(apiKey)"
        performRequest(url: url) { requestResult in
            switch requestResult {
                case .success(let data):
                    do {
                        let detailData = try JSONDecoder().decode(MovieDetailData.self, from: data)
                        result(.success(detailData))
                    } catch {
                        result(.failure(APIError.invalidData))
                    }
                case .failure(let error):
                    result(.failure(error))
            }
        }
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
                return "There is no data in the response"
            case .invalidData:
                return "The data is not valid"
        }
    }
}
