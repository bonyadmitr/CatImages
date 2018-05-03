//
//  FailableClickGestureRecognizer.swift
//  CatImages-iOS
//
//  Created by Bondar Yaroslav on 5/3/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation

/// delegates of both gestures are used, self and otherGestureRecognizer in require(toFail
final class FailableClickGestureRecognizer: NSClickGestureRecognizer {
    
    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        delegate = self
    }
    
    var otherGestureRecognizer: NSGestureRecognizer? {
        didSet {
            otherGestureRecognizer?.delegate = self
        }
    }
    
    func require(toFail otherGestureRecognizer: NSGestureRecognizer) {
        self.otherGestureRecognizer = otherGestureRecognizer
    }
}

extension FailableClickGestureRecognizer: NSGestureRecognizerDelegate {
    
    /// https://forums.developer.apple.com/thread/21347
    func gestureRecognizer(_ gestureRecognizer: NSGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: NSGestureRecognizer) -> Bool {
        if gestureRecognizer == self, self.otherGestureRecognizer == otherGestureRecognizer {
            return true
        }
        return false
    }
}

/// Basic solution
///
//let clickGesture = NSClickGestureRecognizer(target: self, action: #selector(getNewCat))
//clickGesture.delegate = self
//view.addGestureRecognizer(clickGesture)
//
//let doubleClickGesture = NSClickGestureRecognizer(target: self, action: #selector(openApp))
//doubleClickGesture.numberOfClicksRequired = 2
//doubleClickGesture.delegate = self
//view.addGestureRecognizer(doubleClickGesture)
//
//extension FailableGestureRecognizer: NSGestureRecognizerDelegate {
//    
//    /// https://forums.developer.apple.com/thread/21347
//    func gestureRecognizer(_ gestureRecognizer: NSGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: NSGestureRecognizer) -> Bool {
//        if let gestureRecognizer1 = gestureRecognizer as? NSClickGestureRecognizer,
//            let gestureRecognizer2 = otherGestureRecognizer as? NSClickGestureRecognizer,
//            gestureRecognizer1.numberOfClicksRequired == 1,
//            gestureRecognizer2.numberOfClicksRequired == 2
//        {
//            return true
//        }
//        return false
//    }
//}
