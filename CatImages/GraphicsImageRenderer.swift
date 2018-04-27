//
//  GraphicsImageRenderer.swift
//  CatImages-iOS
//
//  Created by Bondar Yaroslav on 4/27/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//


// MARK: Views
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

// UIKit/Cocoa Classes
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


/// https://gist.github.com/erica/ec3e2a4a8526e3fc3ba1fc95a0d53083
import Foundation

// Frameworks
#if os(OSX)
import Cocoa
#else
import UIKit
#endif

#if os(OSX)
public class MacGraphicsImageRendererFormat: NSObject {
    public var opaque: Bool = false
    public var prefersExtendedRange: Bool = false
    public var scale: CGFloat = 2.0
    public var bounds: CGRect = .zero
}

public typealias GraphicsImageRendererFormat = MacGraphicsImageRendererFormat
#else
public typealias GraphicsImageRendererFormat = UIGraphicsImageRendererFormat
#endif

#if os(OSX)
public class MacGraphicsImageRendererContext: NSObject {
    
    public var format: GraphicsImageRendererFormat
    
    public var cgContext: CGContext {
        guard let context = NSGraphicsContext.current?.cgContext
            else { fatalError("Unavailable cgContext while drawing") }
        return context
    }
    
    public func clip(to rect: CGRect) {
        cgContext.clip(to: rect)
    }
    
    public func fill(_ rect: CGRect) {
        cgContext.fill(rect)
    }
    
    public func fill(_ rect: CGRect, blendMode: CGBlendMode) {
        NSGraphicsContext.saveGraphicsState()
        cgContext.setBlendMode(blendMode)
        cgContext.fill(rect)
        NSGraphicsContext.restoreGraphicsState()
    }
    
    public func stroke(_ rect: CGRect) {
        cgContext.stroke(rect)
    }
    
    public func stroke(_ rect: CGRect, blendMode: CGBlendMode) {
        NSGraphicsContext.saveGraphicsState()
        cgContext.setBlendMode(blendMode)
        cgContext.stroke(rect)
        NSGraphicsContext.restoreGraphicsState()
    }
    
    public override init() {
        self.format = GraphicsImageRendererFormat()
        super.init()
    }
    
    public var currentImage: NSImage {
        guard let cgImage = cgContext.makeImage()
            else { fatalError("Cannot retrieve cgImage from current context") }
        return NSImage(cgImage: cgImage, size: format.bounds.size)
    }
}

public typealias GraphicsImageRendererContext = MacGraphicsImageRendererContext
#else
public typealias GraphicsImageRendererContext = UIGraphicsImageRendererContext
#endif

#if os(OSX)
public class MacGraphicsImageRenderer: NSObject {
    
    public class func context(with format: GraphicsImageRendererFormat) -> CGContext? {
        fatalError("Not implemented")
    }
    
    public class func prepare(_ context: CGContext, with: GraphicsImageRendererContext) {
        fatalError("Not implemented")
    }
    
    public class func rendererContextClass() {
        fatalError("Not implemented")
    }
    
    public var allowsImageOutput: Bool = true
    
    public let format: GraphicsImageRendererFormat
    
    public let bounds: CGRect
    
    public init(bounds: CGRect, format: GraphicsImageRendererFormat) {
        (self.bounds, self.format) = (bounds, format)
        self.format.bounds = self.bounds
        super.init()
    }
    
    public convenience init(size: CGSize, format: GraphicsImageRendererFormat) {
        self.init(bounds: CGRect(origin: .zero, size: size), format: format)
    }
    
    public convenience init(size: CGSize) {
        self.init(bounds: CGRect(origin: .zero, size: size), format: GraphicsImageRendererFormat())
    }
    
    public func image(actions: @escaping (GraphicsImageRendererContext) -> Void) -> NSImage {
        let image = NSImage(size: format.bounds.size, flipped: false) {
            (drawRect: NSRect) -> Bool in
            
            let imageContext = GraphicsImageRendererContext()
            imageContext.format = self.format
            actions(imageContext)
            
            return true
        }
        return image
    }
    
    public func pngData(actions: @escaping (GraphicsImageRendererContext) -> Void) -> Data {
        let image = self.image(actions: actions)
        var imageRect = CGRect(origin: .zero, size: image.size)
        guard let cgImage = image.cgImage(forProposedRect: &imageRect, context: nil, hints: nil)
            else { fatalError("Could not construct PNG data from drawing request") }
        let bitmapRep = NSBitmapImageRep(cgImage: cgImage)
        bitmapRep.size = image.size
        guard let data = bitmapRep.representation(using: .png, properties: [:])
            else { fatalError("Could not retrieve data from drawing request") }
        return data
    }
    
    public func jpegData(withCompressionQuality compressionQuality: CGFloat, actions: @escaping (GraphicsImageRendererContext) -> Void) -> Data {
        let image = self.image(actions: actions)
        var imageRect = CGRect(origin: .zero, size: image.size)
        guard let cgImage = image.cgImage(forProposedRect: &imageRect, context: nil, hints: nil)
            else { fatalError("Could not construct PNG data from drawing request") }
        let bitmapRep = NSBitmapImageRep(cgImage: cgImage)
        bitmapRep.size = image.size
        
        guard let data = bitmapRep.representation(using: .jpeg, properties: [NSBitmapImageRep.PropertyKey.compressionFactor: compressionQuality])
            else { fatalError("Could not retrieve data from drawing request") }
        return data
    }
    
    public func runDrawingActions(_ drawingActions: (GraphicsImageRendererContext) -> Void, completionActions: ((GraphicsImageRendererContext) -> Void)? = nil) throws {
        fatalError("Not implemented")
    }
}
#endif

#if os(OSX)
public typealias GraphicsImageRenderer = MacGraphicsImageRenderer
#else
public typealias GraphicsImageRenderer = UIGraphicsImageRenderer
#endif
