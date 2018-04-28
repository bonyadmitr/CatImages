//
//  SharedUserDefaults.swift
//  CatImages-iOS-widget
//
//  Created by Bondar Yaroslav on 4/28/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation

/// Remember: Torn on AppGroups for main and extension targets
/// Remember: set file for all targets
final class SharedUserDefaults {
    
    static let shared = SharedUserDefaults()
    
    let userDefaults = UserDefaults(suiteName: "")!
    
    var shownCounter: Int {
        get { return userDefaults.integer(forKey: "shownCounter") }
        set { userDefaults.set(newValue, forKey: "shownCounter") }
    }
    
    var someText: String? {
        get { return userDefaults.string(forKey: "someText") }
        set { userDefaults.set(newValue, forKey: "someText") }
    }
}
