//
//  NSUserNotification+Init.swift
//  CatImages-iOS
//
//  Created by Bondar Yaroslav on 04/05/2018.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation
import NotificationCenter

/// add NSUserNotificationCenter.default.delegate = self
//extension AppDelegate: NSUserNotificationCenterDelegate {
//    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
//        return true
//    }
//}
extension NSUserNotification {
    convenience init(title: String?, message: String?) {
        self.init()
        self.title = title
        self.informativeText = message
        soundName = NSUserNotificationDefaultSoundName
    }
    
    func show() {
        NSUserNotificationCenter.default.deliver(self)
    }
}
