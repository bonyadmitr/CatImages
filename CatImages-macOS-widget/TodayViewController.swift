//
//  TodayViewController.swift
//  CatImages-macOS-widget
//
//  Created by Bondar Yaroslav on 4/28/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Cocoa
import NotificationCenter

///TODO
//copy to copyboard button
//share in extension menu
//toolbar mac os
//share in toolbar mac os

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
    
    private lazy var mainView = view as! DisablableView
    
    private lazy var catService = CatService()
    
    private var currentImageData: Data?
    
    /// don't need
    //override var nibName: NSNib.Name? {
    //    return NSNib.Name("TodayViewController")
    //}
    
    private var imageConextMenu = ImageConextMenu()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageConextMenu.imageDelegate = self
        
        /// to activate view.layer
        view.wantsLayer = true
        /// to activate view for gestures and mouse clicks
        view.layer?.backgroundColor = NSColor(white: 1, alpha: 0.001).cgColor
        
//        NCWidgetController.widgetController().setHasContent(true, forWidgetWithBundleIdentifier: "com.by.CatImages-macOS.CatImages-macOS-widget")
//        preferredContentSize = NSSize(width: <#T##CGFloat#>, height: <#T##CGFloat#>)
    }
    
    /// https://stackoverflow.com/a/28202696
    override func mouseDown(with event: NSEvent) {
        /// command + left click
        if event.modifierFlags.intersection(.deviceIndependentFlagsMask) == [.command] {
            openImageConextMenu(with: event)
        /// left click
        } else {
            getRandomImage()
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
    
    private func getRandomImage() {
        print("getRandomImage")
        
        mainView.ignoresMouseEvents = true
        catImageProgressIndicator.startAnimation(nil)
        
        catService.getRandom { [weak self] result in
            guard let `self` = self else {
                return
            }
            
            DispatchQueue.main.async {
                self.mainView.ignoresMouseEvents = false
                self.catImageProgressIndicator.stopAnimation(nil)
                
                switch result {
                case .success(let data):
                    self.currentImageData = data
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

extension TodayViewController: ImageConextMenuDelegate {
    func imageConextMenuImageData() -> Data? {
        return currentImageData
    }
}
