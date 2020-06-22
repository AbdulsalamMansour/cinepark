//
//  NetworkingConstants.swift
//  cinepark
//
//  Created by Abdulsalam Mansour on 6/22/20.
//  Copyright © 2020 abdulsalam. All rights reserved.
//

import Foundation

struct NetworkingConstants {
    
    static let baseUrl  = "https://api.themoviedb.org/3/"
    static let apiKey   = ""
    
    struct Parameters {

    }
    
    enum HttpHeaderField: String {
        case authentication = "Authorization"
        case contentType = "Content-Type"
        case acceptType = "Accept"
        case acceptEncoding = "Accept-Encoding"
    }
    
    enum ContentType: String {
        case json = "application/json"
        case form = "application/x-www-form-urlencoded"
    }
}

enum ApiError: Error {
    case unauthorized           //Status code 401
    case notFound               //Status code 404
    case internalServerError    //Status code 500
    case badRequest             //Status code 400
    case serverError
}
