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
    
//    override init(window: NSWindow?) {
//        super.init(window: window)
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        
//    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        if let vc = contentViewController as? CatViewController {
            toolBar.customDelegate = vc
        }
        
//        guard let window = window else {
//            return
//        }
        
//        let toolbar = Toolbar(identifier: NSToolbar.Identifier(rawValue: "ToolBar"))
//        /// Set the delegate of the toolbar before adding the toolbar to the window
//        /// https://stackoverflow.com/a/38405301
//        toolbar.delegate = toolbar
//        window.toolbar = toolbar
    }
}
