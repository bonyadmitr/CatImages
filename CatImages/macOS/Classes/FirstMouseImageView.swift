//
//  FirstMouseImageView.swift
//  CatImages-iOS
//
//  Created by Bondar Yaroslav on 5/25/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Cocoa

class FirstMouseImageView: NSImageView {
    
    override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
        return true
    }
    
//    override func shouldDelayWindowOrdering(for event: NSEvent) -> Bool {
//        return true
//    }
//
//    override func mouseDown(with event: NSEvent) {
//        NSApp.preventWindowOrdering()
//        super.mouseDown(with: event)
//    }
}
