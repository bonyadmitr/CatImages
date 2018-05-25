//
//  NSWindow+Extensions.swift
//  CatImages-macOS
//
//  Created by Bondar Yaroslav on 5/25/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Cocoa

extension NSWindow {
    
    /// moves the window to the front of all apps (include current front app)
    /// https://stackoverflow.com/questions/5364460/keep-nswindow-front
    var keepOnTop: Bool {
        get {
            return level == .floating
        }
        set {
            if newValue {
                level = .floating
            } else {
                level = .normal
            }
        }
    }
}
