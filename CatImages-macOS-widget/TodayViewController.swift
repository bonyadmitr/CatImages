//
//  TodayViewController.swift
//  CatImages-macOS-widget
//
//  Created by Bondar Yaroslav on 4/28/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Cocoa
import NotificationCenter

/// https://stackoverflow.com/a/32447474
//class View: NSView {
//    override func performKeyEquivalent(with event: NSEvent) -> Bool {
//        return true
//    }
//}

/// https://developer.apple.com/library/content/documentation/General/Conceptual/ExtensibilityPG/Today.html
///
/// mac-today-extension must be sandboxed to debug
class TodayViewController: NSViewController {

    static var currentImageData: Data?
    
    @IBOutlet private weak var catImageView: NSImageView! {
        didSet {
            catImageView.imageScaling = .scaleProportionallyUpOrDown
        }
    }
    
    @IBOutlet private weak var catImageProgressIndicator: NSProgressIndicator! {
        didSet {
            catImageProgressIndicator.isDisplayedWhenStopped = false
        }
    }
    
    private lazy var catService = CatService()
    
    /// don't need
//    override var nibName: NSNib.Name? {
//        return NSNib.Name("TodayViewController")
//    }
    
//    override func keyDown(with event: NSEvent) {
//        print(event)
//    }
    
    private var imageConextMenu = ImageConextMenu(title: "ImageConextMenu title")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// to activate view.layer
        view.wantsLayer = true
        /// to activate view for gesture
        view.layer?.backgroundColor = NSColor(white: 1, alpha: 0.001).cgColor
        
//        let doubleClickGesture = NSClickGestureRecognizer(target: self, action: #selector(openApp))
//        doubleClickGesture.numberOfClicksRequired = 2
//        view.addGestureRecognizer(doubleClickGesture)
        
//        let clickGesture = FailableClickGestureRecognizer(target: self, action: #selector(getNewCat))
//        clickGesture.require(toFail: doubleClickGesture)
//        view.addGestureRecognizer(clickGesture)
        
//        let rightClickGesture = NSClickGestureRecognizer(target: self, action: #selector(openApp))
//        rightClickGesture.buttonMask = 0x2 //0x2 right mouse button, 0x1 left
//        view.addGestureRecognizer(rightClickGesture)
        
        /// https://stackoverflow.com/a/32447474
        /// add NSEvent.removeMonitor
//        NSEvent.addLocalMonitorForEvents(matching: .flagsChanged) {
//            self.flagsChanged(with: $0)
//            return $0
//        }
        
//        NCWidgetController.default().setHasContent(true, forWidgetWithBundleIdentifier: "com.by.CatImages-macOS.CatImages-macOS-widget")
//        preferredContentSize = NSSize(width: <#T##CGFloat#>, height: <#T##CGFloat#>)
    }
    
//    override func flagsChanged(with event: NSEvent) {
//        switch event.modifierFlags.intersection(.deviceIndependentFlagsMask) {
//        case [.command]:
//            print("command")
//        default:
//            break
//        }
//    }
    
    /// https://stackoverflow.com/a/28202696
    override func mouseDown(with event: NSEvent) {
        
        /// command + left click
        if event.modifierFlags.intersection(.deviceIndependentFlagsMask) == [.command] {
            
            /// sync func. waiting hiding of menu
            openImageConextMenu(with: event)
            
        /// left click
        } else {
            
            view.window?.ignoresMouseEvents = true
            view.acceptsTouchEvents = true
            catImageProgressIndicator.startAnimation(nil)
            
            catService.getRandom { [weak self] result in
                guard let `self` = self else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.view.window?.ignoresMouseEvents = false
                    self.catImageProgressIndicator.stopAnimation(nil)
                    
                    switch result {
                    case .success(let data):
                        TodayViewController.currentImageData = data
                        if let image = Image(data: data) {
                            self.catImageView.image = image
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
            
        }

    }
    
    /// right mouse click
    override func rightMouseDown(with event: NSEvent) {
        openImageConextMenu(with: event)
    }
    
    /// sync func. waiting hiding of menu
    private func openImageConextMenu(with event: NSEvent) {
        NSMenu.popUpContextMenu(imageConextMenu, with: event, for: catImageView)
    }
    
    @objc private func getNewCat(_ gesture: NSClickGestureRecognizer) {
        catService.setRandomImage(enablable: gesture,
                                  activityIndicator: catImageProgressIndicator,
                                  imageView: catImageView)
        
//        gesture.isEnabled = false
//        catImageProgressIndicator.startAnimation(nil)
//
//        catService.getRandomImage { [weak self] result in
//            guard let `self` = self else {
//                return
//            }
//
//            DispatchQueue.main.async {
//
//                gesture.isEnabled = true
//                self.catImageProgressIndicator.stopAnimation(nil)
//
//                switch result {
//                case .success(let image):
//                    self.catImageView.image = image
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//            }
//        }
    }
    
    @objc private func openApp(_ gesture: NSClickGestureRecognizer) {
        print("openApp")
        let url = URL(string: "main-app://")!
        
        /// https://stackoverflow.com/a/28446720/5893286
        NSWorkspace.shared.open(url)
//        extensionContext?.open("main-app://")
    }
}

// TODO: CHECK protocols
//NCWidgetListViewDelegate
//NCWidgetSearchViewDelegate

extension TodayViewController: NCWidgetProviding {
    
    @available(OSX 10.10, *)
    func widgetPerformUpdate(completionHandler: @escaping (NCUpdateResult) -> Void) {
        // Update your data and prepare for a snapshot. Call completion handler when you are done
        // with NoData if nothing has changed or NewData if there is new data since the last
        // time we called you
        catService.getRandomImage { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self?.catImageView.image = image
                case .failure(let error):
                    print(error.localizedDescription)
                } 
            }
        }
        
        completionHandler(.newData)
    }
    
    /// Override the left margin so that the list view is flush with the edge.
    func widgetMarginInsets(forProposedMarginInsets defaultMarginInset: NSEdgeInsets) -> NSEdgeInsets {
        var defaultMarginInset = defaultMarginInset
        defaultMarginInset.left = 5
        return defaultMarginInset
    }
    
    /// Return true to indicate that the widget supports editing of content and
    /// that the list view should be allowed to enter an edit mode.
    var widgetAllowsEditing: Bool {
        return false
    }
    
    /* Called in response to the begin editing button when widgetAllowsEditing. */
    //func widgetDidBeginEditing() {}
    
    
    /* Called in response to the end editing button when widgetAllowsEditing.
     This will also be called when the widget is deactivated in response to
     another widget being edited. */
    //func widgetDidEndEditing() {}
}
