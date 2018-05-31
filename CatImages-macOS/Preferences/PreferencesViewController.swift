//
//  PreferencesViewController.swift
//  CatImages-macOS
//
//  Created by Bondar Yaroslav on 5/28/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Cocoa

final class PreferencesViewController: NSViewController {
    
    @IBOutlet private weak var keepOnTopButton: NSButton! {
        willSet {
            newValue.title = "Keep on top"
        }
    }
    @IBOutlet private weak var widgetHeightTextFiled: NSTextField! {
        didSet {
            widgetHeightTextFiled.formatter = OnlyIntegerValueFormatter()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
        
        // Set the size for each views
        //self.preferredContentSize = NSMakeSize(self.view.frame.size.width, self.view.frame.size.height)
        preferredContentSize = view.frame.size
    }
    
    private func setupBindings() {
        widgetHeightTextFiled.bind(.value, key: BindKeys.widgetHeightTextFiled)
        keepOnTopButton.bind(.value, key: BindKeys.keepOnTopButton)
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        // Update window title with the active TabView Title
        if let title = title {
            parent?.view.window?.title = title
        }
    }
    
}
