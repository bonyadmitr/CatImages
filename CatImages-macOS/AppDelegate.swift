//
//  AppDelegate.swift
//  CatImages-macOS
//
//  Created by Bondar Yaroslav on 4/26/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Cocoa

/// README
/// some files are not in targets at all
/// NSApplication.shared == NSApp

/// posible settings
// TODO: check video player settings for more features
/// - keep on top check box
/// - auto save to pictures
/// - create folder in pictures
/// - disable "save to pictures" button after 1 save
/// - auto change cat timer with time setup
/// - add share button
/// - widget height
/// - added link to api


// TODO: NSProgressIndicator color
// TODO: add NSTouchBar
// TODO: open app menu with data
// TODO: local notification by time (and disable it)
// TODO: settings menu and window
// TODO: about
// TODO: add tool bar item OPEN PICTURES

// TODO: optimize and clear SaveManager
// TODO: optimize and clear CatService

// TODO: CustomErrors: system or unknown naming ???
/// It is System error. Send report how did you get it, please. and Button with text "Send report" to email

// TODO: check all code in unknownError NSError
// TODO: maybe add to CustomErrors system case bcz it is localized string
/// localizedDescription: "The requested operation couldn’t be completed because the feature is not supported."
/// localized. example ru: "Операцию не удалось завершить, так как эта функция не поддерживается."
///let unknownError = NSError(domain: NSCocoaErrorDomain, code: NSFeatureUnsupportedError, userInfo: [:])

// TODO: windowShouldClose, return NSvc commitEditing()


//        @IBAction func quit(_ sender: NSMenuItem) {
//            NSApp.terminate(nil)
//        }
//
//        @IBAction func about(_ sender: NSMenuItem) {
//            NSApp.orderFrontStandardAboutPanel(self)
//        }


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
    
    private lazy var preferencesWindowController: NSWindowController? = {
        let storyboard = NSStoryboard(name: .preferences, bundle: nil)
        return storyboard.instantiateInitialController() as? NSWindowController
    }()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        print("- NSHomeDirectory:", NSHomeDirectory())
        
        // Here we just opt-in for allowing our instance of the NSTouchBar class to be customized throughout the app.
        if #available(OSX 10.12.2, *) {
            NSApplication.shared.isAutomaticCustomizeTouchBarMenuItemEnabled = true
        }
    }
    
    @IBAction func showPreferences(_ sender: NSMenuItem) {
        preferencesWindowController?.showWindow(sender)
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
//extension AppDelegate: NSUserNotificationCenterDelegate {
//    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
//        return true
//    }
//}
