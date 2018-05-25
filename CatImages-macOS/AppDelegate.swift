//
//  AppDelegate.swift
//  CatImages-macOS
//
//  Created by Bondar Yaroslav on 4/26/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Cocoa

/// NSApplication.shared == NSApp

/// posible settings
// TODO: check video player settings for more features
/// - keep on top check box
/// - auto save to pictures
/// - create folder in pictures
/// - disable "save to pictures" button after save
/// - auto change cat timer with time setup
/// - add share button


/// https://gist.github.com/shpakovski/7585136
/// How to customize NSButton for the image and no background
//1. Drag and drop `Push` buton to the XIB and change its title;
//2. Configure bindings and actions, test that the button works as expected;
//3. Uncheck the flag `Bordered` in the Attributes inspector;
//4. Change Type to `Momentary Change`;
//5. Set an appropriate image name;
//6. Change Position to `Image Only`;
//7. Change Scaling to `None`;
//8. Configure size and auto layout if needed.

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
    }

    func application(_ application: NSApplication, open urls: [URL]) {
    }
    
    /// to open app after close button click we only hide it
    /// https://stackoverflow.com/a/43332520
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if !flag {
            for window in sender.windows {
                window.makeKeyAndOrderFront(self)
            }
        }
        
        return true
    }
}


/// add NSUserNotificationCenter.default.delegate = self
///
//extension AppDelegate: NSUserNotificationCenterDelegate {
//    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
//        return true
//    }
//}
