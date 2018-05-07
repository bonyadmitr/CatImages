//
//  ViewController.swift
//  CatImages-macOS
//
//  Created by Bondar Yaroslav on 4/26/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Cocoa

/// don't forget about sanbox and "outgoing connections"


/**
 min OSX
 NSViewController viewDidLoad 10.10
 Swift 10.9
 Storyboards are not available before macOS 10.10
 
 OS X Yosemite - 10.10
 OS X Mavericks - 10.9
 */
final class CatViewController: NSViewController {
    
    private var currentImageData: Data?
    
    private lazy var mainView = view as! DisablableView
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageConextMenu.imageDelegate = self
        getRandomImage()
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    private var imageConextMenu = ImageConextMenu()
    
    
    
    
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

extension CatViewController: ImageConextMenuDelegate {
    func imageConextMenuImageData() -> Data? {
        return currentImageData
    }
}
