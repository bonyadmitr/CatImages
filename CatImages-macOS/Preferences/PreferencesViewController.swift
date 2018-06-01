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
    @IBOutlet private weak var titleVisibilityButton: NSButton! {
        willSet {
            newValue.title = "Show title"
        }
    }
    @IBOutlet private weak var transparentTitlebarButton: NSButton! {
        willSet {
            newValue.title = "Transparent titlebar"
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
        keepOnTopButton.bind(.value, key: BindKeys.keepOnTopButton)
        titleVisibilityButton.bind(.value, key: BindKeys.titleVisibilityButton)
        transparentTitlebarButton.bind(.value, key: BindKeys.transparentTitlebarButton)
        widgetHeightTextFiled.bind(.value, key: BindKeys.widgetHeightTextFiled)
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        // Update window title with the active TabView Title
        if let title = title {
            parent?.view.window?.title = title
        }
    }
    
}
