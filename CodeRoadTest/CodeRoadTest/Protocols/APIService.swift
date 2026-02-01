//
//  APIService.swift
//  CodeRoadTest
//
//  Created by Omar Barrera Peña on 31/01/26.
//

import Foundation

/**
 Protocol that sets the basic methods to create a service layer
 */
protocol APIService {
    /**
     Fetch a list of items based on a key-word
     
     - Parameters:
        - title: The key-word to perform the search task
        - result: Result that contains the list of items returned based on a key-word or the returned error
     */
    func getList(title: String, result: @escaping (Result<SearchData, Error>) -> Void)
    /**
     Fetch an image data
     
     - Parameters:
        - imageURL: The key-word to perform the search task
        - result: Result that contains the data retaled to the image or the returned error
     */
    func getImage(imageURL: String, result: @escaping (Result<Data, Error>) -> Void)
    /**
     Fetch data of an specific item
     
     - Parameters:
        - id: The id of an item
        - result: Result that contains the data of the item or the returned error
     */
    func getDetails(id: String, result: @escaping (Result<MovieDetailData, Error>) -> Void)
}

extension APIService {
    /**
     Performs a call to a service and returns the response
     
     - Parameters:
        - url: The URL of the service
        - result: Result that contains the response from the service or the returned error
     */
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
