//
//  ApiRouter.swift
//  cinepark
//
//  Created by Abdulsalam Mansour on 6/22/20.
//  Copyright © 2020 abdulsalam. All rights reserved.
//

import Foundation
import Alamofire

enum ApiRouter: URLRequestConvertible {
    
    case getPopularMovies(page: Int)
    case getPopularTv(page: Int)

    
    //MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try NetworkingConstants.baseUrl.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        urlRequest.timeoutInterval = 60 //seconds
        
        urlRequest.setValue(NetworkingConstants.apiKey, forHTTPHeaderField: NetworkingConstants.HttpHeaderField.authentication.rawValue)
        urlRequest.setValue(NetworkingConstants.ContentType.json.rawValue, forHTTPHeaderField: NetworkingConstants.HttpHeaderField.acceptType.rawValue)
        urlRequest.setValue(NetworkingConstants.ContentType.json.rawValue, forHTTPHeaderField: NetworkingConstants.HttpHeaderField.contentType.rawValue)
        
        let encoding: ParameterEncoding = {
            switch method {
            case .get:
                return URLEncoding.default
            default:
                return JSONEncoding.default
            }
        }()
        
        return try encoding.encode(urlRequest, with: parameters)
        
    }
    
    //MARK: - HttpMethod
    private var method: HTTPMethod {
        switch self {
        case .getPopularMovies:
            return .get
            
        case .getPopularTv:
            return .get
    
        }
    }
    
    //MARK: - Path
    private var path: String {
        switch self {
        case .getPopularMovies:
            return "movie/popular"
            
        case .getPopularTv:
            return "tv/popular"
        }
    }
    
    //MARK: - Parameters
    private var parameters: Parameters? {
        switch self {
        case .getPopularMovies(let page):
            return [NetworkingConstants.Parameters.page : page]
            
        case .getPopularTv(let page):
            return [NetworkingConstants.Parameters.page : page]
        }
    }
}
