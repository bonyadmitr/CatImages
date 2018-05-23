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

final class Toolbar: NSToolbar {
    
    weak var customDelegate: ToolbarDelegate?
    
    @IBAction private func saveInPictures(_ sender: NSToolbarItem) {
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
