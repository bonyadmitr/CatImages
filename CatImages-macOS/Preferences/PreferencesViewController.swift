//
//  PreferencesViewController.swift
//  CatImages-macOS
//
//  Created by Bondar Yaroslav on 5/28/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Cocoa

final class PreferencesViewController: NSViewController {
    
    @IBOutlet private weak var keepOnTopButton: NSButton!
    @IBOutlet private weak var widgetHeightTextFiled: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setupUserDefaults()
        
        // Set the size for each views
        //self.preferredContentSize = NSMakeSize(self.view.frame.size.width, self.view.frame.size.height)
        preferredContentSize = view.frame.size
    }
    
    private func setupUserDefaults() {
        let defaults = NSUserDefaultsController.shared
        let options = [NSBindingOption.continuouslyUpdatesValue: true]
        widgetHeightTextFiled.bind(.value, to: defaults, withKeyPath: "widgetHeightTextFiled.value", options: options)
        keepOnTopButton.bind(.value, to: defaults, withKeyPath: "keepOnTopButton.value", options: options)
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        // Update window title with the active TabView Title
        if let title = title {
            parent?.view.window?.title = title
        }
    }
    
}
