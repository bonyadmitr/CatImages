//
//  UIKit_Cocoa_typealias.swift
//  CatImages-iOS
//
//  Created by Bondar Yaroslav on 5/26/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation

// MARK: Frameworks
#if os(OSX)
import Cocoa
#else
import UIKit
#endif

// MARK: View
#if os(iOS)
public typealias View = UIView
#elseif os(OSX)
public class View: NSView {
    public var alpha: CGFloat {
        get { return alphaValue }
        set { alphaValue = newValue }
    }
}
#endif

// MARK: UIKit/Cocoa Classes
#if os(OSX)
//public typealias View = NSView
public typealias Font = NSFont
public typealias Color = NSColor
//public typealias Image = NSImage
public typealias BezierPath = NSBezierPath
public typealias ViewController = NSViewController
#else
//public typealias View = UIView
public typealias Font = UIFont
public typealias Color = UIColor
//public typealias Image = UIImage
public typealias BezierPath = UIBezierPath
public typealias ViewController = UIViewController
#endif
