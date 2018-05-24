//
//  AppDelegate.swift
//  CatImages-macOS
//
//  Created by Bondar Yaroslav on 4/26/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Cocoa

@NSApplicationMain
final class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        print("NSHomeDirectory:", NSHomeDirectory())
        
        
        // Here we just opt-in for allowing our instance of the NSTouchBar class to be customized throughout the app.
        if #available(OSX 10.12.2, *) {
            NSApplication.shared.isAutomaticCustomizeTouchBarMenuItemEnabled = true
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func application(_ application: NSApplication, open urls: [URL]) {
        
    }
}


/// add NSUserNotificationCenter.default.delegate = self
///
//extension AppDelegate: NSUserNotificationCenterDelegate {
//    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
//        return true
//    }
//}
