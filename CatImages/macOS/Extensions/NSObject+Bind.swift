//
//  NSObject+Bind.swift
//  CatImages-iOS
//
//  Created by Bondar Yaroslav on 5/31/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Cocoa

extension NSObject {
    func bind(_ binding: NSBindingName, key: String) {
        let defaults = NSUserDefaultsController.shared
        let options = [NSBindingOption.continuouslyUpdatesValue: true]
        bind(binding, to: defaults, withKeyPath: "values.\(key)", options: options)
    }
}
