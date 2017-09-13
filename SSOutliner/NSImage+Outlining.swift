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
    func addingOutline(with opts: Options) -> NSImage {
        
        
        let lineWidth = opts.lineThickness
        let size = CGSize(width: self.size.width + lineWidth * 2,
                          height: self.size.height + lineWidth * 2)
        let newImage = NSImage(size: size)

        newImage.lockFocus() /* Start Drawing */
        
        // Draw the screenshot itself
        draw(at: NSPoint(x: lineWidth, y: lineWidth),
             from: NSRect.zero,
             operation: NSCompositingOperation.copy,
             fraction: 1.0)
        
        // corner radii
        let bottomLeftRadius = opts.radius(for: .bottomLeft) - lineWidth
        let bottomRightRadius = opts.radius(for: .bottomRight) - lineWidth
        let topRightRadius = opts.radius(for: .topRight) - lineWidth
        let topLeftRadius = opts.radius(for: .topLeft) - lineWidth
        
        // mayberounded rect
        let path = NSBezierPath()
        let inset = lineWidth / 2.0
        path.appendArc(withCenter: NSPoint(x: bottomLeftRadius + inset,
                                           y: bottomLeftRadius + inset),
                       radius: bottomLeftRadius,
                       startAngle: 180,
                       endAngle: 270)
        path.appendArc(withCenter: NSPoint(x: size.width - bottomRightRadius - inset,
                                           y: bottomRightRadius + inset),
                       radius: bottomRightRadius,
                       startAngle: 270,
                       endAngle: 360)
        path.appendArc(withCenter: NSPoint(x: size.width - topRightRadius - inset,
                                           y: size.height - topRightRadius - inset),
                       radius: topRightRadius,
                       startAngle: 0,
                       endAngle: 90)
        path.appendArc(withCenter: NSPoint(x: topLeftRadius + inset,
                                           y: size.height - topLeftRadius - inset),
                       radius: topLeftRadius,
                       startAngle: 90,
                       endAngle: 180)
        path.close()
        
        path.lineWidth = lineWidth
        NSColor.black.setStroke()
        path.stroke()
        
        newImage.unlockFocus() /* Done Drawing */
        
        return newImage
    }
    
    func PNGRepresentation() -> Data {
        return NSBitmapImageRep(data: tiffRepresentation!)!.representation(using: .PNG,
                                                                           properties: [:])!
    }
}
