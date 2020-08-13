import Cocoa
import CoreGraphics

extension NSImage {
    func addingOutline(mask: CornerMask, radius: CGFloat, width lineWidth: CGFloat) -> NSImage {
        
        
        let size = CGSize(width: self.size.width + lineWidth * 2,
                          height: self.size.height + lineWidth * 2)
        let newImage = NSImage(size: size)
        
        // Draw the screenshot itself
        draw(at: NSPoint(x: lineWidth, y: lineWidth),
             from: NSRect.zero,
             operation: NSCompositingOperation.copy,
             fraction: 1.0)
        
        // Each corner radius is 0 (if not in the mask) or the specified radius, less the line width
        let bottomLeftRadius = (mask.contains(.bottomLeft) ? radius : 0) - lineWidth
        let bottomRightRadius = (mask.contains(.bottomRight) ? radius : 0) - lineWidth
        let topRightRadius = (mask.contains(.topRight) ? radius : 0) - lineWidth
        let topLeftRadius = (mask.contains(.topLeft) ? radius : 0) - lineWidth
        
        // Define the pseudorounded rect
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
                
        return newImage
    }
}
