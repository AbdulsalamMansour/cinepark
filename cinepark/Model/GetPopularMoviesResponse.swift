//
//  GetPopularMoviesResponse.swift
//  cinepark
//
//  Created by Abdulsalam Mansour on 6/22/20.
//  Copyright © 2020 abdulsalam. All rights reserved.
//

import Foundation

// MARK: - GetPopularMoviesResponse
struct GetPopularResponse: Codable {
    let page, totalResults, totalPages: Int?
    let results: [Result]?

    enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results
    }
}
