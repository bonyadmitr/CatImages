//
//  HyperlinkTextField.swift
//  CatImages-iOS
//
//  Created by Bondar Yaroslav on 6/4/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Cocoa

/// https://stackoverflow.com/a/46897824/5893286
@IBDesignable final class HyperlinkTextField: NSTextField {
    
    @IBInspectable var href: String = ""
    
    override func resetCursorRects() {
        /// Invalidates all cursor rectangles set up using addCursorRect(_:cursor:).
        discardCursorRects()
        
        /// change text cursor icon to the pointingHand one
        addCursorRect(bounds, cursor: .pointingHand)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        isEditable = false
        drawsBackground = false
        isBordered = false
        
//        isSelectable = false
//        allowsEditingTextAttributes = false
        
        let attributes: [NSAttributedStringKey: Any] = [.foregroundColor: NSColor.blue,
                                                        .underlineStyle: NSUnderlineStyle.styleSingle.rawValue]
        attributedStringValue = NSAttributedString(string: stringValue, attributes: attributes)
    }
    
    override func mouseDown(with theEvent: NSEvent) {
        if let url = URL(string: href) {
            NSWorkspace.shared.open(url)
        }
    }
}
