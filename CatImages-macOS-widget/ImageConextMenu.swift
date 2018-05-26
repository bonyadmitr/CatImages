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
        let saveItem = NSMenuItem(title: "Save in Pictures",
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
        
        do {
            try SaveManager.save(data: imageData, name: Constants.defaultSaveImageName)
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    @objc private func saveAs() {
        guard let imageData = imageDelegate?.imageConextMenuImageData() else {
            return
        }
        
        SaveManager.saveAs(data: imageData, name: Constants.defaultSaveImageName) { result in
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
