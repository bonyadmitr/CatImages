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

/// https://developer.apple.com/library/content/samplecode/ToolbarSample/Introduction/Intro.html
/// removed autovalidation of NSToolbarItems in IB
/// removed selectable of NSToolbarItems in IB
final class Toolbar: NSToolbar {
    
    weak var customDelegate: ToolbarDelegate?
    
    private var fileMonitor: FileMonitor?
    
    private var saveInPicturesBarItem: NSToolbarItem?
    
    override init(identifier: NSToolbar.Identifier) {
        super.init(identifier: identifier)
        
        // TODO: test first start values
//        displayMode = .labelOnly
//        sizeMode = .regular

        NotificationCenter.default.addObserver(self, selector: #selector(didGetNewImage), name: .didGetNewImage, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didSaveInPictures), name: .didSaveInPictures, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func didGetNewImage(_ notification: Notification) {
        saveInPicturesBarItem?.isEnabled = true
    }
    
    @objc private func didSaveInPictures(_ notification: Notification) {
        saveInPicturesBarItem?.isEnabled = false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        /// Set the delegate of the toolbar before adding the toolbar to the window
        /// https://stackoverflow.com/a/38405301
        ///delegate = self
        
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
        /// !!! not working when NSToolbar inits from IB so setup it in IB
        autosavesConfiguration = true
        
        // Tell the toolbar to show icons only by default.
        /// !!! will rewrite user settings here
//        displayMode = .labelOnly
//        sizeMode = .small
        
        showsBaselineSeparator = false
    }
    
    @IBAction private func saveInPictures(_ sender: NSToolbarItem) {
        guard let imageData = customDelegate?.passImageData() else {
            return
        }
        
        do {
            let pictureUrl = try SaveManager.save(data: imageData, name: Constants.defaultSaveImageName)
            
            /// event .rename work for "move to trash"
            /// event .attrib called after file saving/observer added
            fileMonitor = FileMonitor(withFilePath: pictureUrl.path, observeEvent: [.rename, .delete], queue: .main)
            fileMonitor?.onFileEvent = {
                NotificationCenter.default.post(name: .didGetNewImage, object: nil)
            }
            
            saveInPicturesBarItem = sender
            NotificationCenter.default.post(name: .didSaveInPictures, object: nil)
        } catch  {
            NSAlert.showError(message: error.localizedDescription)
        }
    }
    
    @IBAction private func saveAs(_ sender: NSToolbarItem) {
        guard let imageData = customDelegate?.passImageData() else {
            return
        }
        
        SaveManager.saveAs(data: imageData, name: Constants.defaultSaveImageName) { result in
            switch result {
            case .success:
                print("success")
            case .failure(let error):
                NSAlert.showError(message: error.localizedDescription)
            case .cancel:
                print("cancel")
            }
        }
    }
}

//extension Toolbar: NSToolbarDelegate {
//
//    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
//        return [NSToolbarItem.Identifier.save, .saveAs]
//    }
//    
//    func toolbarSelectableItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
//        return [NSToolbarItem.Identifier.flexibleSpace, .space]
//    }
// 
//
///**
// NSToolbar delegates require this function. It returns an array holding identifiers for all allowed
// toolbar items in this toolbar. Any not listed here will not be available in the customization palette.
// */
//    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
//        return [NSToolbarItem.Identifier.flexibleSpace, .space]
//    }
//    
//
//    /// https://christiantietze.de/posts/2016/06/segmented-nstoolbaritem/
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
