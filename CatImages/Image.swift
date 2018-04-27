//
//  Image.swift
//  CatImages-iOS
//
//  Created by Bondar Yaroslav on 4/27/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
public typealias Image = UIImage
#elseif os(macOS)
import Cocoa
public typealias Image = NSImage
#endif

extension Image {
    /// Bundle(for: Image.self)
    func image(name: String, from bundle: Bundle) -> Image? {
        #if os(iOS) || os(tvOS) // TODO: check for os(watchOS)
        return Image(named: name, in: bundle, compatibleWith: nil)
        #elseif os(macOS)
        return bundle.image(forResource: NSImage.Name(name))
        #endif
    }
    
    convenience init?(assetName: String) {
        #if os(iOS) || os(tvOS) // TODO: check for os(watchOS)
        self.init(named: assetName)
        #elseif os(macOS)
        self.init(named: NSImage.Name(assetName))
        #endif
    }
    
    /// https://gist.github.com/erica/ec3e2a4a8526e3fc3ba1fc95a0d53083
    var pngData: Data? {
        #if os(iOS) || os(tvOS) // TODO: check for os(watchOS)
        return UIImagePNGRepresentation(self)
        #elseif os(macOS)
        
        var imageRect = CGRect(origin: .zero, size: size)
        guard let cgImage = cgImage(forProposedRect: &imageRect, context: nil, hints: nil) else {
            return nil
        }
        let bitmapRep = NSBitmapImageRep(cgImage: cgImage)
        bitmapRep.size = size
        return bitmapRep.representation(using: .png, properties: [:])
        
        #endif
    }
}
