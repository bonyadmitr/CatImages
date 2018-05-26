//
//  CustomErrors.swift
//  CatImages-macOS
//
//  Created by Bondar Yaroslav on 5/23/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation

//let unknownError = NSError(domain: NSCocoaErrorDomain, code: NSFeatureUnsupportedError, userInfo: [:])

enum CustomErrors {
    case system
    case debugString(String)
}
extension CustomErrors: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .system:
            return "System error"
        case .debugString(let text):
            #if DEBUG
            return text
            #else
            return "System error"
            #endif
        }
    }
}
