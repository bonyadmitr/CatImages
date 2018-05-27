//
//  NSAlert+Init.swift
//  CatImages-iOS
//
//  Created by Bondar Yaroslav on 5/27/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Cocoa

/// https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/Dialog/Dialog.html
/// if called some alerts system shows them in queue

extension NSAlert {
    
    convenience init(title: String, message: String, style: NSAlert.Style) {
        self.init()
        messageText = title
        informativeText = message
        alertStyle = style
    }
    
    func show() {
        runModal()
    }
    
    func show(handler: @escaping BoolResult) {
        
        let resultHandler: (NSApplication.ModalResponse) -> Void = { result in
            switch result {
            case .alertFirstButtonReturn:
                handler(.success(true))
            case .alertSecondButtonReturn:
                handler(.success(false))
            default:
                let errorString = "\(result), raw: \(result.rawValue)" 
                let error = CustomErrors.systemDebug(errorString)
                print("⚠️", error.localizedDescription)
                handler(.failure(error))
            }
        }
        
        if let window = NSApp.keyWindow {
            beginSheetModal(for: window, completionHandler: resultHandler)
        } else {
            resultHandler(runModal())
        }
    }
    
    func show(firstButtonTitle: String, secondButtonTitle: String) -> Bool {
        addButton(withTitle: firstButtonTitle)
        addButton(withTitle: secondButtonTitle)
        return runModal() == .alertFirstButtonReturn
    }
    
    func showOkCancel() -> Bool {
        return show(firstButtonTitle: "OK", secondButtonTitle: "Cancel")
    }
}
