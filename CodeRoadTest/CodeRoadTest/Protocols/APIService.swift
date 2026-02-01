//
//  APIService.swift
//  CodeRoadTest
//
//  Created by Omar Barrera Peña on 31/01/26.
//

import Foundation

protocol APIService {
    func getList(title: String, result: @escaping (Result<SearchData, Error>) -> Void)
    func getImage(imageURL: String, result: @escaping (Result<Data, Error>) -> Void)
    func getDetails(id: String, result: @escaping (Result<MovieDetailData, Error>) -> Void)
}

extension APIService {
    func performRequest(url: String, result: @escaping(Result<Data, Error>) -> Void) {
        guard let url = URL(string: url) else {
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
            result(.success(data))
        }
        task.resume()
    }
}
