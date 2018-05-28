//
//  PreferencesWindowController.swift
//  CatImages-macOS
//
//  Created by Bondar Yaroslav on 5/28/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Cocoa

class PreferencesWindowController: NSWindowController, NSWindowDelegate {
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        window?.keepOnTop = true
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        // Hide the window instead of closing
        window?.orderOut(sender)
        return false
    }
    
}
