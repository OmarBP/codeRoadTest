//
//  RatingData.swift
//  CodeRoadTest
//
//  Created by Omar Barrera Peña on 30/01/26.
//

/**
 Data model that contains the rating data about a movie or serie from a specific source
 */
struct RatingData: Codable {
    let source: String
    let value: String
    
    enum CodingKeys: String, CodingKey {
        case source = "Source"
        case value = "Value"
    }
}
