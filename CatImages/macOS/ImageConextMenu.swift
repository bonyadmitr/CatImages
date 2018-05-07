//
//  ImageConextMenu.swift
//  CatImages-macOS-widget
//
//  Created by Bondar Yaroslav on 5/4/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Cocoa

protocol ImageConextMenuDelegate: class {
    func imageConextMenuImageData() -> Data?
}

final class ImageConextMenu: NSMenu {
    
    convenience init() {
        self.init(title: "")
    }
    
    override init(title: String) {
        super.init(title: title)
        setup()
    }
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)
        setup()
    }
    
    private func setup() {
        /// use or autoenablesItems = false
        /// or override func validateMenuItem(_ menuItem: NSMenuItem) -> Bool
        autoenablesItems = false
        seupItems()
    }
    
    private func seupItems() {
        let openInWindowItem = NSMenuItem(title: "Open in window",
                                          action: #selector(openInWindow),
                                          keyEquivalent: "o")
        let saveItem = NSMenuItem(title: "Save in Images",
                                  action: #selector(saveInImages),
                                  keyEquivalent: "s")
        let saveAsItem = NSMenuItem(title: "Save as...",
                                    action: #selector(saveAs),
                                    keyEquivalent: "S")
        
        /// keyEquivalent: "s" with keyEquivalentModifierMask [.command, .shift] ==
        /// keyEquivalent: "S" with keyEquivalentModifierMask [.command] or default keyEquivalentModifierMask
        //saveAsItem.keyEquivalentModifierMask = [.command, .shift]
        
        /// add target or action will not work
        /// and NSMenuItem will be disabled with "autoenablesItems = true"(default value)
        openInWindowItem.target = self
        saveItem.target = self
        saveAsItem.target = self
        
        addItem(openInWindowItem)
        addItem(NSMenuItem.separator())
        addItem(saveItem)
        addItem(saveAsItem)
    }
    
    /// use or autoenablesItems = false
    /// or override func validateMenuItem(_ menuItem: NSMenuItem) -> Bool
    //    override func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
    //        return true
    //    }
    
    weak var imageDelegate: ImageConextMenuDelegate?
    
    @objc private func openInWindow(_ menuItem: NSMenuItem) {
        let url = URL(string: "main-app://")!
        /// https://stackoverflow.com/a/28446720/5893286
        NSWorkspace.shared.open(url)
    }
    
    @objc private func saveInImages() {
        
        guard let imageData = imageDelegate?.imageConextMenuImageData() else {
            return
        }
        
        /// Capabilities - File Access list - Pictures Folder - Read/Write
        let pictureDirectories = NSSearchPathForDirectoriesInDomains(.picturesDirectory, [.userDomainMask], true)
        
        guard let pictureFolderPath = pictureDirectories.first else {
            return
        }
        let pictureFolderUrl = URL(fileURLWithPath: pictureFolderPath + "/someImage.jpg")
        
        do {
            try imageData.write(to: pictureFolderUrl)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @objc private func saveAs() {
        
        guard let imageData = imageDelegate?.imageConextMenuImageData() else {
            return
        }
        
        
        
        
        //        CFStringRef newExtension = UTTypeCopyPreferredTagWithClass((CFStringRef)typeUTI,
        //                                                                   kUTTagClassFilenameExtension);
        //        NSString* newName = [[name stringByDeletingPathExtension]
        //            stringByAppendingPathExtension:(NSString*)newExtension];
        
        
        /// error: caught non-fatal NSInternalInconsistencyException 'bridge absent' with backtrace
        /// Capabilities - File Access list - User Selected File - Read/Write
        /// https://stackoverflow.com/a/48248271
        ///
        /// https://developer.apple.com/library/content/documentation/FileManagement/Conceptual/FileSystemProgrammingGuide/UsingtheOpenandSavePanels/UsingtheOpenandSavePanels.html
        let savePanel = NSSavePanel()
        
        
        
        // TODO: enable window of NSSavePanel, allow editing
        // TODO: open app menu
        // TODO: local notification by time (and disable it)
        // TODO: settings menu and window
        // TODO: about
        
        
        //        @IBAction func quit(_ sender: NSMenuItem) {
        //            NSApp.terminate(nil)
        //        }
        //
        //        @IBAction func about(_ sender: NSMenuItem) {
        //            NSApp.orderFrontStandardAboutPanel(self)
        //        }
        
        
        /// https://stackoverflow.com/a/42857068
        savePanel.allowedFileTypes = ["jpg", "png"] //NSImage.imageTypes
        savePanel.allowsOtherFileTypes = true
        savePanel.nameFieldStringValue = "someImageName"
        
        /// string displayed in front of the filename text field
        savePanel.nameFieldLabel = "nameFieldLabel"
        
        /// default button
        savePanel.prompt = "savePanel.prompt"
        
        
        savePanel.begin { result in
            
            
            //NSFileHandlingPanelOKButton
            if result == NSApplication.ModalResponse.OK {
                guard let fileUrl = savePanel.url else {
                    return
                }
                
                do {
                    try imageData.write(to: fileUrl)
                } catch {
                    print(error.localizedDescription)
                }
            }
            
        }
        
    }
    
}
