//
//  CatService.swift
//  CatImages
//
//  Created by Bondar Yaroslav on 4/26/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation

typealias VoidResult = (ResponseResult<Void>) -> Void
typealias BoolResult = (ResponseResult<Bool>) -> Void
typealias DataResult = (ResponseResult<Data>) -> Void
typealias HandlerResult<T> = (ResponseResult<T>) -> Void
typealias ArrayHandlerResult<T> = (ResponseResult<[T]>) -> Void

enum ResponseResult<T> {
    case success(T)
    case failure(Error)
}


final class CatService {
    
    func getRandom(handler: @escaping DataResult) {
        let url = URL(string: "https://thecatapi.com/api/images/get")!
        let catApiKey = "MzA0NjAy"
        
        var request = URLRequest(url: url)
        request.addValue(catApiKey, forHTTPHeaderField: "api_key")
//        request.timeoutInterval = timeoutInterval
//        request.httpMethod = method.rawValue
//        request.httpBody = body
//        request.allHTTPHeaderFields = headerParametrs
//        request.cachePolicy = .reloadRevalidatingCacheData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                handler(.success(data))
            }
        }.resume()
    }
    
}
