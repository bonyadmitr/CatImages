//
//  OnlyIntegerValueFormatter.swift
//  CatImages-iOS
//
//  Created by Bondar Yaroslav on 5/31/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation

/// https://stackoverflow.com/a/39935157/5893286
final class OnlyIntegerValueFormatter: NumberFormatter {
    
    override func isPartialStringValid(_ partialString: String, newEditingString newString: AutoreleasingUnsafeMutablePointer<NSString?>?, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        
        /// Ability to reset your field (otherwise you can't delete the content)
        if partialString.isEmpty {
            return true
        }
        
        /// Optional: limit input length
        //if partialString.count > 3 {
        //    return false
        //}
        
        if Int(partialString) == nil {
            /// soundName in Resources as a .wav file
            //let beep = NSSound(named: NSSound.Name(rawValue: "soundName"))
            //beep?.play()
            NSSound.beep()
            return false
        }
        
        return true
    }
}
