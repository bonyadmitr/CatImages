//
//  WindowController.swift
//  CatImages-macOS
//
//  Created by Bondar Yaroslav on 5/22/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Cocoa

final class WindowController: NSWindowController {
    
    @IBOutlet private weak var toolBar: Toolbar!
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        
        if let vc = contentViewController as? CatViewController {
            toolBar.customDelegate = vc
        }
        
        guard let window = window else {
            return
        }
        
        window.title = "Cat Images"
        
        
        /// http://robin.github.io/cocoa/mac/2016/03/28/title-bar-and-toolbar-showcase/
//        window.titleVisibility = .hidden /// compact tool bar
//        window.titlebarAppearsTransparent = true
//        window.styleMask = .fullSizeContentView
        
        /// not working for me
//        window.isMovableByWindowBackground = true
        
        
//        let toolbar = Toolbar(identifier: NSToolbar.Identifier(rawValue: "ToolBar"))
//        /// Set the delegate of the toolbar before adding the toolbar to the window
//        /// https://stackoverflow.com/a/38405301
//        toolbar.delegate = toolbar
//        window.toolbar = toolbar
    }
}
