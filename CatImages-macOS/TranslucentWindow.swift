//
//  TranslucentWindow.swift
//  CatImages-macOS
//
//  Created by Bondar Yaroslav on 5/24/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Cocoa

/// https://gist.github.com/eonist/0c3cb90b5ad9ebcea83a
final class TranslucentWindow: NSWindow, NSApplicationDelegate, NSWindowDelegate {
    
    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        //        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
        
        super.init(contentRect: contentRect, styleMask: [.titled, .resizable, .miniaturizable, .closable, .fullSizeContentView], backing: .buffered, defer: false)
        
        guard let contentView = contentView else {
            return
        }
        
        //        contentView?.wantsLayer = true /*this can and is set in the view*/
        //        backgroundColor = NSColor.green.withAlphaComponent(0.2)
        isOpaque = false
        //        makeKeyAndOrderFront(nil)//moves the window to the front
        //        makeMain()//makes it the apps main menu?
        //self.appearance = NSAppearance(named: NSAppearanceNameVibrantDark)
        //        titlebarAppearsTransparent = true
        
        //        center()
        
        //self.contentView = view
        //self.title = ""/*Sets the title of the window*/
        //        title = ""
        
        //        delegate = self
        
        let rect =  NSRect(x: 0, y: 0, width: 1000, height: 1000)
        let visualEffectView = NSVisualEffectView(frame: rect)
        visualEffectView.material = .dark//Dark,MediumLight,PopOver,UltraDark,AppearanceBased,Titlebar,Menu
        visualEffectView.blendingMode = .behindWindow
        visualEffectView.state = .active
        contentView.addSubview(visualEffectView)
        
        //        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        //        if #available(OSX 10.11, *) {
        //            visualEffectView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        //        } else {
        //            // Fallback on earlier versions
        //        }
        
        //self.contentView = visualEffectView
        
        /* self.contentView!.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[visualEffectView]-0-|", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil, views: ["visualEffectView":visualEffectView]))
         self.contentView!.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[visualEffectView]-0-|", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil, views: ["visualEffectView":visualEffectView]))
         */
        //visualEffectView.wantsLayer = true;//this should be set in the iew not here
        //visualEffectView.allowsVibrancy.interiorBackgroundStyle // only radable
        //visualEffectView.allowsVibrancy = true
        //visualEffectView.blendingMode = NSVisualEffectBlendingModeWithinWindow,
        
    }
}
