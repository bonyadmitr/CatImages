//
//  Window.swift
//  CatImages-macOS
//
//  Created by Bondar Yaroslav on 5/24/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Cocoa

/// added views to contentView not working with vc and without it
final class Window: NSWindow, NSApplicationDelegate, NSWindowDelegate {
    
    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        //        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
        
        super.init(contentRect: contentRect, styleMask: [.titled, .resizable, .miniaturizable, .closable], backing: .buffered, defer: false)
        
//        backgroundColor = NSColor.white.withAlphaComponent(0.2)
//        isOpaque = false
        makeKeyAndOrderFront(nil)//moves the window to the front
        makeMain()//makes it the apps main menu?
//        self.appearance = NSAppearance(named: NSAppearance.Name.vibrantDark)
//        titlebarAppearsTransparent = true
//        title = ""
//        center()
        
//        guard let contentView = contentView else {
//            return
//        }
    }
}
