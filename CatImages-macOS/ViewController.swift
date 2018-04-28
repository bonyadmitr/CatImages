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
    
    @IBOutlet private weak var catImageView: NSImageView!
    
    private lazy var catService = CatService()
    
    override func viewDidLoad() {
        
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
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
}

