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
    
    private var saveInPicturesMenuItem: NSMenuItem?
    private var fileMonitor: FileMonitor?
    
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
        setupItems()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didGetNewImage), name: .didGetNewImage, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didSaveInPictures), name: .didSaveInPictures, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func didGetNewImage(_ notification: Notification) {
        saveInPicturesMenuItem?.isEnabled = true
    }
    
    @objc private func didSaveInPictures(_ notification: Notification) {
        saveInPicturesMenuItem?.isEnabled = false
    }
    
    private func setupItems() {
        let openInWindowItem = NSMenuItem(title: "Open in window",
                                          action: #selector(openInWindow),
                                          keyEquivalent: "o")
        let saveInPicturesItem = NSMenuItem(title: "Save in Pictures",
                                  action: #selector(saveInPictures),
                                  keyEquivalent: "s")
        let saveAsItem = NSMenuItem(title: "Save as...",
                                    action: #selector(saveAs),
                                    keyEquivalent: "S")
        
        saveInPicturesMenuItem = saveInPicturesItem
        
        /// keyEquivalent: "s" with keyEquivalentModifierMask [.command, .shift] ==
        /// keyEquivalent: "S" with keyEquivalentModifierMask [.command] or default keyEquivalentModifierMask
        //saveAsItem.keyEquivalentModifierMask = [.command, .shift]
        
        /// add target or action will not work
        /// and NSMenuItem will be disabled with "autoenablesItems = true"(default value)
        openInWindowItem.target = self
        saveInPicturesItem.target = self
        saveAsItem.target = self
        
        addItem(openInWindowItem)
        addItem(NSMenuItem.separator())
        addItem(saveInPicturesItem)
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
    
    @objc private func saveInPictures() {
        guard let imageData = imageDelegate?.imageConextMenuImageData() else {
            return
        }
        
        do {
            let pictureUrl = try SaveManager.saveImage(data: imageData, name: Constants.defaultSaveImageName, folderName: Constants.defaultSavingFolderName)
            
            fileMonitor = FileMonitor(withFilePath: pictureUrl.path, observeEvent: [.rename, .delete], queue: .main)
            fileMonitor?.onFileEvent = {
                NotificationCenter.default.post(name: .didGetNewImage, object: nil)
            }
            
            NotificationCenter.default.post(name: .didSaveInPictures, object: nil)
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
