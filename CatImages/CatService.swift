//
//  CatService.swift
//  CatImages
//
//  Created by Bondar Yaroslav on 4/26/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation

typealias HandlerResult<T> = (ResponseResult<T>) -> Void
typealias ArrayHandlerResult<T> = (ResponseResult<[T]>) -> Void

typealias VoidResult = (ResponseResult<Void>) -> Void
typealias BoolResult = (ResponseResult<Bool>) -> Void
typealias DataResult = (ResponseResult<Data>) -> Void

typealias ImageResult = (ResponseResult<Image>) -> Void

enum ResponseResult<T> {
    case success(T)
    case failure(Error)
}

let unknownError = NSError(domain: NSCocoaErrorDomain, code: NSFeatureUnsupportedError, userInfo: [:])

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
    
    func getRandomImage(handler: @escaping ImageResult) {
        getRandom { result in
            switch result {
            case .success(let data):
                if let image = Image(data: data) {
                    handler(.success(image))
                } else {
                    handler(.failure(unknownError))
                }
            case .failure(let error):
                handler(.failure(error))
            } 
        }
    }
    
    /// using:
    /// catService.setRandomImage(enablable: gesture, activityIndicator: catImageProgressIndicator, imageView: catImageView)
    func setRandomImage(enablable: Enablable, activityIndicator: ActivityIndicator, imageView: ImageView) {
        
        activityIndicator.startAnimating()
        enablable.isEnabled = false
        
        getRandomImage { result in
            DispatchQueue.main.async {
                enablable.isEnabled = true
                activityIndicator.stopAnimating()
                
                switch result {
                case .success(let image):
                    imageView.image = image
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}
