//
//  ViewController.swift
//  CatImages-macOS
//
//  Created by Bondar Yaroslav on 4/26/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Cocoa

/// don't forget about sanbox and outgoing requests

class ViewController: NSViewController {
    
    @IBOutlet private weak var catImageView: NSImageView!
    
    private lazy var catService = CatService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        catService.getRandom { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    let image = NSImage(data: data)
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

