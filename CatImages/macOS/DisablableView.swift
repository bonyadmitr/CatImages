//
//  DisablableView.swift
//  CatImages-iOS
//
//  Created by Bondar Yaroslav on 5/7/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Cocoa

class DisablableView: NSView {
    
    var ignoresMouseEvents = false
    
//    override func hitTest(_ point: NSPoint) -> NSView? {
//        if !ignoresMouseEvents {
//            return super.hitTest(point)
//        }
//        return nil
//    }
    
    override func mouseDown(with event: NSEvent) {
        if ignoresMouseEvents {
            return
        }
        
        /// prevent click to drag window by titleBar
        if let window = window, window.titlebarAppearsTransparent == true {
            let yFromTop = window.frame.height - event.locationInWindow.y
            if yFromTop < Constants.windowTitleBarHeightWithHiddenTitle {
                return
            }
        }
        
        super.mouseDown(with: event)
    }
    
    override func rightMouseDown(with event: NSEvent) {
        if !ignoresMouseEvents {
            super.rightMouseDown(with: event)
        }
    }
    
    override func otherMouseDown(with event: NSEvent) {
        if !ignoresMouseEvents {
            super.otherMouseDown(with: event)
        }
    }
    
    override func scrollWheel(with event: NSEvent) {
        if !ignoresMouseEvents {
            super.scrollWheel(with: event)
        }
    }
    
    // MARK: - backgroundColor
    
    var backgroundColor: NSColor?
    
    /// https://stackoverflow.com/a/48510638
    override func draw(_ dirtyRect: NSRect) {
        if let backgroundColor = backgroundColor {
            backgroundColor.setFill()
            dirtyRect.fill()
        } else {
            super.draw(dirtyRect)
        }
    }
}
