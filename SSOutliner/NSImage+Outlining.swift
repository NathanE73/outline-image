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
    func addingOutline(_ i: Instructions) -> NSImage {
        
        let size = CGSize(width: self.size.width + i.lineThickness * 2,
                          height: self.size.height + i.lineThickness * 2)
        let newImage = NSImage(size: size)
        

        newImage.lockFocus() /* Start Drawing */
        
        // Draw the screenshot itself
        draw(at: NSPoint(x: i.lineThickness, y: i.lineThickness),
             from: NSRect.zero,
             operation: NSCompositingOperation.copy,
             fraction: 1.0)
        
        let path = NSBezierPath()
        path.lineWidth = i.lineThickness
        NSColor.black.setStroke()
        
        // corner radii
        let bottomLeftRadius = i.radius(for: .bottomLeft)
        let bottomRightRadius = i.radius(for: .bottomRight)
        let topRightRadius = i.radius(for: .topRight)
        let topLeftRadius = i.radius(for: .topLeft)
        
        // bottom left corner
        if bottomLeftRadius != 0 {
            path.appendArc(withCenter: NSPoint(x: bottomLeftRadius,
                                               y: bottomLeftRadius),
                           radius: bottomLeftRadius,
                           startAngle: CGFloat.pi * 1.5,
                           endAngle: CGFloat.pi,
                           clockwise: false)
        }
        
        // bottom edge
        path.move(to: NSPoint(x: bottomLeftRadius, y: 0))
        path.line(to: NSPoint(x: size.width - bottomRightRadius, y: 0))
        
        // bottom right corner
        if bottomRightRadius != 0 {
            path.appendArc(withCenter: NSPoint(x: size.width - bottomRightRadius,
                                               y: bottomRightRadius),
                           radius: bottomRightRadius,
                           startAngle: CGFloat.pi,
                           endAngle: CGFloat.pi / 2.0,
                           clockwise: false)
        }
        
        // right edge
        path.move(to: NSPoint(x: size.width, y: bottomRightRadius))
        path.line(to: NSPoint(x: size.width, y: size.height - topRightRadius))
        
        // top right corner
        if topRightRadius != 0 {
            path.appendArc(withCenter: NSPoint(x: size.width - topRightRadius,
                                               y: size.height - topRightRadius),
                           radius: topRightRadius,
                           startAngle: CGFloat.pi / 2.0,
                           endAngle: 0.0,
                           clockwise: false)
        }
        
        // top edge
        path.move(to: NSPoint(x: size.width - topRightRadius, y: size.height))
        path.line(to: NSPoint(x: topLeftRadius, y: size.height))
        
        // top left corner
        if topLeftRadius != 0 {
            path.appendArc(withCenter: NSPoint(x: topLeftRadius,
                                               y: size.height - topLeftRadius),
                           radius: topLeftRadius,
                           startAngle: 0,
                           endAngle: CGFloat.pi / 2.0,
                           clockwise: false)
        }
        
        // left edge
        path.move(to: NSPoint(x: 0, y: size.height - topLeftRadius))
        path.line(to: NSPoint(x: 0, y: bottomLeftRadius))
        
        path.stroke()
        
        newImage.unlockFocus() /* Done Drawing */
        
        return newImage
    }
    
    func PNGRepresentation() -> Data {
        return NSBitmapImageRep(data: tiffRepresentation!)!.representation(using: .PNG,
                                                                           properties: [:])!
    }
}
