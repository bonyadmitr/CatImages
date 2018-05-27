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
    
    @IBOutlet private weak var catImageView: NSImageView! {
        didSet {
            catImageView.imageScaling = .scaleProportionallyUpOrDown
            
            /// https://stackoverflow.com/questions/24323274/nsimageview-and-resizing-of-window
            let imagePriority = NSLayoutConstraint.Priority.windowSizeStayPut - 1 /// 499
            catImageView.setContentCompressionResistancePriority(imagePriority, for: .horizontal)
            catImageView.setContentCompressionResistancePriority(imagePriority, for: .vertical)
        }
    }
    
    @IBOutlet private weak var catImageProgressIndicator: NSProgressIndicator!
    
    private lazy var mainView = view as! DisablableView
    
    private lazy var catService = CatService()
    
    private var currentImageData: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getRandomImage()
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        /// click
        getRandomImage()
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
                
                NotificationCenter.default.post(name: .didGetNewImage, object: nil)
            }
        }
    }
}

extension CatViewController: ToolbarDelegate {
    func passImageData() -> Data? {
        return currentImageData
    }
}

