//
//  ProgressIndicator.swift
//  CatImages-macOS
//
//  Created by Bondar Yaroslav on 5/26/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Cocoa

final class ProgressIndicator: NSProgressIndicator {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        style = .spinning
        controlSize = .regular
        isDisplayedWhenStopped = false
        //        controlTint = .clearControlTint
    }
}
