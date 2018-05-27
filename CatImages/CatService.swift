//
//  CatService.swift
//  CatImages
//
//  Created by Bondar Yaroslav on 4/26/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation

final class CatService {
    
    private let url = URL(string: "https://thecatapi.com/api/images/get")!
    private let catApiKey = "MzA0NjAy"
    
    func getRandom(handler: @escaping DataResult) {
        // TODO: check: reuse of URLRequest. one init 
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
            } else if let error = error {
                handler(.failure(error))
            } else {
                let error = CustomErrors.systemDebug(response?.description ?? "response nil")
                handler(.failure(error))
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
                    handler(.failure(CustomErrors.system))
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
