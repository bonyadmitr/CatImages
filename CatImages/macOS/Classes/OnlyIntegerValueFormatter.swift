//
//  OnlyIntegerValueFormatter.swift
//  CatImages-iOS
//
//  Created by Bondar Yaroslav on 5/31/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation
import Cocoa /// only for NSSound

/// https://stackoverflow.com/a/39935157/5893286
final class OnlyIntegerValueFormatter: NumberFormatter {
    
//    override func string(for obj: Any?) -> String? {
//        guard let str = obj as? String else {
//            return nil
//        }
//        return str
//    }
//    
//    override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
//        
//        if let number = Int(string), number > 400 {
//            obj?.pointee = "400" as AnyObject?
////            playErrorSound()
//            return false
//        } else {
//            obj?.pointee = string as AnyObject
//        }
//        
//        return true
//    }
    
    /// you can't change text here, only validate
    override func isPartialStringValid(_ partialString: String, newEditingString newString: AutoreleasingUnsafeMutablePointer<NSString?>?, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        
        /// Ability to reset your field (otherwise you can't delete the content)
        if partialString.isEmpty {
            return true
        }
        
        /// Optional: limit input length
        //if partialString.count > 3 {
        //    return false
        //}
        
        /// check only number
        if Int(partialString) == nil {
            playErrorSound()
            return false
        }
        
        /// check max number
//        if let number = Int(partialString) {
//            if number > 400 {
////                partialString = "400"
//                playErrorSound()
//                return true
//            }
//            return true
//        } else {
//            playErrorSound()
//            return false
//        }
        
        return true
    }
    
    private func playErrorSound() {
        /// soundName in Resources as a .wav file
        //let beep = NSSound(named: NSSound.Name(rawValue: "soundName"))
        //beep?.play()
        NSSound.beep()
    }
}
