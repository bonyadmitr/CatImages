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

protocol ImageView: class {
    var image: Image? { get set }
}

protocol Enablable: class {
    var isEnabled: Bool { get set }
}

#if os(iOS) || os(tvOS) || os(watchOS)

import UIKit

extension UIActivityIndicatorView: ActivityIndicator {}
extension UIImageView: ImageView {}
extension UIGestureRecognizer: Enablable {}

#elseif os(macOS)

import Cocoa
//import AppKit

/// catImageProgressIndicator.isDisplayedWhenStopped = false
extension NSProgressIndicator: ActivityIndicator {
    func startAnimating() {
        startAnimation(nil)
    }
    
    func stopAnimating() {
        stopAnimation(nil)
    }
}

extension NSImageView: ImageView {}
extension NSGestureRecognizer: Enablable {}

#endif
