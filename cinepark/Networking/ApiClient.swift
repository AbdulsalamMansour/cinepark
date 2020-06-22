//
//  ApiClient.swift
//  cinepark
//
//  Created by Abdulsalam Mansour on 6/22/20.
//  Copyright © 2020 abdulsalam. All rights reserved.
//

import RxSwift
import Alamofire

class ApiClient {
    
    static func getPopularMovies() -> Observable<GetPopularResponse> {
        return request(ApiRouter.getPopularMovies)
    }
    
    static func getPopularTv() -> Observable<GetPopularResponse>{
        return request(ApiRouter.getPopularTv)
    }
    
    //MARK:- Building The Request
    private static func request<T: Codable> (_ urlConvertible: URLRequestConvertible) -> Observable<T> {
        return Observable<T>.create { observer in
            let request = AF.request(urlConvertible).responseDecodable { (response: AFDataResponse<T>) in
                switch response.result {
                case .success(let value):
                    observer.onNext(value)
                    observer.onCompleted()
                case .failure(let error):
                    switch response.response?.statusCode {
                    case 401:
                        observer.onError(ApiError.unauthorized)
                    case 400:
                        observer.onError(ApiError.badRequest)
                    case 404:
                        observer.onError(ApiError.notFound)
                    case 500:
                        observer.onError(ApiError.internalServerError)
                    default:
                        observer.onError(error)
                    }
                }
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
