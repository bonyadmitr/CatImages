//
//  Result.swift
//  CatImages-iOS
//
//  Created by Bondar Yaroslav on 5/26/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation

typealias HandlerResult<T> = (Result<T>) -> Void
typealias ArrayHandlerResult<T> = (Result<[T]>) -> Void

typealias VoidResult = (Result<Void>) -> Void
typealias BoolResult = (Result<Bool>) -> Void
typealias DataResult = (Result<Data>) -> Void

typealias ImageResult = (Result<Image>) -> Void

enum Result<T> {
    case success(T)
    case failure(Error)
}
