//
//  APIError.swift
//  CodeRoadTest
//
//  Created by Omar Barrera Peña on 31/01/26.
//

import Foundation

/**
 Custom errors designed to indicate specific errors for an API call
 */
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
