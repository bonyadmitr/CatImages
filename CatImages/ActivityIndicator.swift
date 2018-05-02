//
//  ActivityIndicator.swift
//  CatImages-iOS
//
//  Created by Bondar Yaroslav on 5/2/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation

protocol ActivityIndicator {
    func startAnimating()
    func stopAnimating()
}

#if os(iOS) || os(tvOS) || os(watchOS)

import UIKit

extension UIActivityIndicatorView: ActivityIndicator {}

#elseif os(macOS)

import Cocoa

/// catImageProgressIndicator.isDisplayedWhenStopped = false
extension NSProgressIndicator: ActivityIndicator {
    func startAnimating() {
        startAnimation(nil)
    }
    
    func stopAnimating() {
        stopAnimation(nil)
    }
}

#endif

