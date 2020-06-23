//
//  Result.swift
//  cinepark
//
//  Created by Abdulsalam Mansour on 6/22/20.
//  Copyright © 2020 abdulsalam. All rights reserved.
//

import Foundation

struct Result: Codable, Hashable{
    
    var posterPath: String?
    var id: Int?
    var originalLanguage: String?
    var title: String?
    var voteAverage: Double?
    var overview, releaseDate: String?
    var name: String?
    var firstAirDate: String?
    
    enum CodingKeys: String, CodingKey {
        case posterPath         = "poster_path"
        case id
        case originalLanguage   = "original_language"
        case title
        case voteAverage        = "vote_average"
        case overview
        case releaseDate        = "release_date"
        case name
        case firstAirDate       = "first_air_date"
    }
    
}
