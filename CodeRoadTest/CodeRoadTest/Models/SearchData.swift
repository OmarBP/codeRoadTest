//
//  SearchData.swift
//  CodeRoadTest
//
//  Created by Omar Barrera Peña on 30/01/26.
//

struct SearchData: Codable {
    let search: [MovieData]
    let totalResults: String
    let response: String
    
    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case response = "Response"
        case totalResults
    }
}
