//
//  Notifications.swift
//  CatImages-iOS
//
//  Created by Bondar Yaroslav on 5/27/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation

extension Notification.Name {
    /// notification to enable save button
    static let didGetNewImage = Notification.Name("didGetNewImage")
    
    /// notification to disable save button
    static let didSaveInPictures = Notification.Name("didSaveInPictures")
}
