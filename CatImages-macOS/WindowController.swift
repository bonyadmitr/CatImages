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
    }
}
