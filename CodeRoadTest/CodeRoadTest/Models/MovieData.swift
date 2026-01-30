//
//  MovieData.swift
//  CodeRoadTest
//
//  Created by Omar Barrera Peña on 30/01/26.
//

struct MovieData: Codable {
    let title: String
    let year: String
    let id: String
    let type: String
    let poster: String
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case id = "imdbID"
        case type = "Type"
        case poster = "Poster"
    }
}
