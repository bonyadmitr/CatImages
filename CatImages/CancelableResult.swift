//
//  CancelableResult.swift
//  CatImages-iOS
//
//  Created by Bondar Yaroslav on 5/26/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation

typealias VoidCancelableResult = (CancelableResult<Void>) -> Void

enum CancelableResult<T> {
    case success(T)
    case failure(Error)
    case cancel
}
