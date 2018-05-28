//
//  PreferencesViewController.swift
//  CatImages-macOS
//
//  Created by Bondar Yaroslav on 5/28/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Cocoa

class PreferencesViewController: NSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the size for each views
        //self.preferredContentSize = NSMakeSize(self.view.frame.size.width, self.view.frame.size.height)
        preferredContentSize = view.frame.size
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        // Update window title with the active TabView Title
        if let title = title {
            parent?.view.window?.title = title
        }
    }
    
}
