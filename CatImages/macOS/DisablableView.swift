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
    
    override func hitTest(_ point: NSPoint) -> NSView? {
        if !ignoresMouseEvents {
            return super.hitTest(point)
        }
        return nil
    }
    
    //    override func mouseDown(with event: NSEvent) {
    //        if !ignoresMouseEvents {
    //            super.mouseDown(with: event)
    //        }
    //    }
    //    
    //    override func rightMouseDown(with event: NSEvent) {
    //        if !ignoresMouseEvents {
    //            super.rightMouseDown(with: event)
    //        }
    //    }
    //    
    //    override func scrollWheel(with event: NSEvent) {
    //        if !ignoresMouseEvents {
    //            super.scrollWheel(with: event)
    //        }
    //    }
}
