//
//  Window.swift
//  CatImages-macOS
//
//  Created by Bondar Yaroslav on 5/24/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Cocoa

/// added views to contentView not working with vc and without it
final class Window: NSWindow, NSApplicationDelegate {
    
    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
        
        
        
//        super.init(contentRect: contentRect, styleMask: [.titled, .resizable, .miniaturizable, .closable, .nonactivatingPanel], backing: .buffered, defer: false)
        
        /// don't set title in init if you use IB
        ///title = "Cat Images"
        
        NotificationCenter.default.addObserver(self, selector: #selector(userDefaultsDidChange), name: UserDefaults.didChangeNotification, object: nil)
    }
    
    @objc private func userDefaultsDidChange(_ notification: Notification) {
        keepOnTop = NSUserDefaultsController.shared.defaults.bool(forKey: "keepOnTopButton")
        print(NSUserDefaultsController.shared.defaults.string(forKey: "widgetHeightTextFiled") ?? "nil")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        title = "Cat Images"
        
        /// moves the window to the front, but below current front app
        makeKeyAndOrderFront(nil)
//        keepOnTop = true
        
//        backgroundColor = NSColor.white.withAlphaComponent(0.2)
//        isOpaque = false
//        makeMain() ///makes it the apps main menu?
//        self.appearance = NSAppearance(named: NSAppearance.Name.vibrantDark)
//        center()

//        guard let contentView = contentView else {
//            return
//        }
        
        /// window customization
        /// http://robin.github.io/cocoa/mac/2016/03/28/title-bar-and-toolbar-showcase/
        
        /// compact tool bar with buttons
        titleVisibility = .hidden
        
        /// clear titlebar.
        /// use with window.styleMask.insert(.fullSizeContentView)
        /// and toolBar.showsBaselineSeparator = false
        ///
        /// !!! NSToolBar can't be edited due to system behavior
        /// use "override func runToolbarCustomizationPalette" to fix it
        titlebarAppearsTransparent = true
        
        /// blured titlebar
        /// views in vc will be under titlebar. need relayout
        /// also https://stackoverflow.com/questions/24414483/how-can-i-use-nsvisualeffectview-in-windows-title-bar
        styleMask.insert(.fullSizeContentView)
        /// for NSPanel.
        //styleMask.insert(.nonactivatingPanel)
        
        /// not working for me. need to test
        isMovableByWindowBackground = true
        
        //hidesOnDeactivate = true
        
        delegate = self
    }

    /// to open app after close button click we only hide it
    /// or use applicationShouldHandleReopen in AppDelegate
    /// https://medium.com/@venj/hide-window-instead-of-close-it-when-clicks-the-close-button-25768e41ee2d
    //func windowShouldClose(_ sender: NSWindow) -> Bool {
    //    NSApp.hide(nil)
    //    //orderOut(nil) /// close but not release from memory
    //    //orderOut(sender) //TODO: check for hide like NSApp.hide(nil)
    //    return false
    //}
    
    /// to edit NSToolBar with "titlebarAppearsTransparent = true"
    override func runToolbarCustomizationPalette(_ sender: Any?) {
        titlebarAppearsTransparent = false
        super.runToolbarCustomizationPalette(sender) /// open model window
        titlebarAppearsTransparent = true
    }
}
extension Window: NSWindowDelegate {
    
    /// AutoHideToolbar in full screen mode
    /// https://stackoverflow.com/a/16027120
    func window(_ window: NSWindow, willUseFullScreenPresentationOptions proposedOptions: NSApplication.PresentationOptions = []) -> NSApplication.PresentationOptions {
        return [NSApplication.PresentationOptions.fullScreen, .hideDock, .autoHideToolbar, .autoHideMenuBar]
    }
}
