//
//  Toolbar.swift
//  CatImages-macOS
//
//  Created by Bondar Yaroslav on 5/23/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Cocoa

protocol ToolbarDelegate: class {
    func passImageData() -> Data?
}

// TODO: add NSTouchBar in subclass and custom window
// TODO: play gif images

/// https://developer.apple.com/library/content/samplecode/ToolbarSample/Introduction/Intro.html
final class Toolbar: NSToolbar {
    
    weak var customDelegate: ToolbarDelegate?
    
    override init(identifier: NSToolbar.Identifier) {
        super.init(identifier: identifier)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
        // Configure our toolbar (note: this can also be done in Interface Builder).
        
        /*  If you pass NO here, you turn off the customization palette. The palette is normally handled
         automatically for you by NSWindow's -runToolbarCustomizationPalette: function; you'll notice
         that the "Customize Toolbar" menu item is hooked up to that method in Interface Builder.
         */
        allowsUserCustomization = true
        
        /*  Tell the toolbar that it should save any configuration changes to user defaults, i.e. mode
         changes, or reordering will persist. Specifically they will be written in the app domain using
         the toolbar identifier as the key.
         */
        autosavesConfiguration = true
        
        // Tell the toolbar to show icons only by default.
        displayMode = .labelOnly
        
        /// Set the delegate of the toolbar before adding the toolbar to the window
        /// https://stackoverflow.com/a/38405301
        ///delegate = self
        
        sizeMode = .small
        allowsUserCustomization = true
        showsBaselineSeparator = true
        
//        items.forEach { $0. = .texturedRounded }
    }
    
    /// removed autovalidation
    @IBAction private func saveInPictures(_ sender: NSToolbarItem) {
        
        // TODO: sender.isEnabled 
        ///sender.isEnabled = false
        guard let data = customDelegate?.passImageData() else {
            return
        }
        
        do {
            try SaveManager.save(data: data, name: Constants.defaultSaveImageName)
//            NSAlert().beginSheetModal(for: <#T##NSWindow#>, completionHandler: <#T##((NSApplication.ModalResponse) -> Void)?##((NSApplication.ModalResponse) -> Void)?##(NSApplication.ModalResponse) -> Void#>)
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    @IBAction private func saveAs(_ sender: NSToolbarItem) {
        guard let data = customDelegate?.passImageData() else {
            return
        }
        
        SaveManager.saveAs(data: data, name: Constants.defaultSaveImageName) { result in
            switch result {
            case .success:
                print("success")
            case .failure(let error):
                print(error.localizedDescription)
            case .cancel:
                print("cancel")
            }
        }
    }
}

//extension Toolbar: NSToolbarDelegate {
//
//    
//    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
//        return [NSToolbarItem.Identifier.save, .saveAs]
//    }
//    
//    func toolbarSelectableItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
//        return [NSToolbarItem.Identifier.flexibleSpace, .space]
//    }
// 

/**
 NSToolbar delegates require this function. It returns an array holding identifiers for all allowed
 toolbar items in this toolbar. Any not listed here will not be available in the customization palette.
 */
//    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
//        return [NSToolbarItem.Identifier.flexibleSpace, .space]
//    }
//    

/// https://christiantietze.de/posts/2016/06/segmented-nstoolbaritem/
//    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
//        
//        
//        let toolbarItem = NSToolbarItem(itemIdentifier: itemIdentifier)
//        let button = NSButton(frame: NSRect(x: 0, y: 0, width: 40, height: 40))
//        button.title = ""
//        button.bezelStyle = .texturedRounded
//        toolbarItem.view = button
//        
//        button.image = #imageLiteral(resourceName: "download_folder")
//        button.imageScaling = .scaleProportionallyUpOrDown
//        
//        if itemIdentifier == .save {
//            let text = "Save in Pictures"
//            toolbarItem.label = text
//            toolbarItem.paletteLabel = text
//
//        } else if itemIdentifier == .saveAs {
//            let text = "Save as..."
//            toolbarItem.label = text
//            toolbarItem.paletteLabel = text
//        }
//        
//        return toolbarItem
//    }
//    
//    func toolbarWillAddItem(_ notification: Notification) {
//        print(notification)
//        print("toolbarWillAddItem", (notification.userInfo?["item"] as? NSToolbarItem)?.itemIdentifier ?? "")
//    }
//}
//
//
//extension NSToolbarItem.Identifier {
//    static let save = NSToolbarItem.Identifier(rawValue: "save")
//    static let saveAs = NSToolbarItem.Identifier(rawValue: "saveAs")
//}
