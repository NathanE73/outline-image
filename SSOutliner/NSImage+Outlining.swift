//
//  NSImage+Outlining.swift
//  SSOutliner
//
//  Created by Michael L. Ward on 1/26/17.
//  Copyright © 2017 Michael L. Ward. All rights reserved.
//

import Cocoa
import CoreGraphics

extension NSImage {
    func addingOutline(thickness: CGFloat,
                       color: NSColor,
                       cornerRadius: CGFloat) -> NSImage {
        
        let newImageSize = CGSize(width: size.width + thickness * 2,
                                  height: size.height + thickness * 2)
        let newImage = NSImage(size: newImageSize)
        

        newImage.lockFocus()
            draw(at: NSPoint(x: thickness, y: thickness),
                 from: NSRect.zero,
                 operation: NSCompositingOperation.copy,
                 fraction: 1.0)
            
            let pathRect = NSRect(x: thickness / 2.0,
                                  y: thickness / 2.0,
                                  width: size.width + thickness,
                                  height: size.height + thickness)
            let path = NSBezierPath(roundedRect: pathRect,
                                    xRadius: cornerRadius,
                                    yRadius: cornerRadius)
            path.lineWidth = thickness
            color.setStroke()
            path.stroke()
        newImage.unlockFocus()
        
        return newImage
    }
    
    var PNGRepresentation: Data {
        return NSBitmapImageRep(data: tiffRepresentation!)!.representation(using: .PNG,
                                                                           properties: [:])!
    }
}
