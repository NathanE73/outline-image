import Cocoa
import CoreGraphics

extension CGImage {
    func addingOutline(mask: CornerMask, radius: Int, width lineWidth: Int) -> CGImage {
        
        let newSize = (width: self.width + lineWidth * 2,
                       height: self.height + lineWidth * 2)
        let newCGSize = CGSize(width: newSize.width, height: newSize.height)
        
        let ctx: CGContext = CGContext(data: nil,
                          width: newSize.width,
                          height: newSize.height,
                          bitsPerComponent: 8,
                          bytesPerRow: 0,
                          space: CGColorSpaceCreateDeviceRGB(),
                          bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        
        // Draw the screenshot itself
        let rect = CGRect(x: lineWidth, y: lineWidth, width: self.width, height: self.height)
        ctx.draw(self, in: rect)
        
        // Each corner radius is 0 (if not in the mask) or the specified radius, less the line width
        let bottomLeftRadius = CGFloat((mask.contains(.bottomLeft) ? radius : 0) - lineWidth)
        let bottomRightRadius = CGFloat((mask.contains(.bottomRight) ? radius : 0) - lineWidth)
        let topRightRadius = CGFloat((mask.contains(.topRight) ? radius : 0) - lineWidth)
        let topLeftRadius = CGFloat((mask.contains(.topLeft) ? radius : 0) - lineWidth)
        
        // Define the pseudorounded rect
        let path = CGMutablePath()
        let inset = CGFloat(lineWidth) / 2.0

        path.addArc(center: CGPoint(x: bottomLeftRadius + inset,
                                    y: bottomLeftRadius + inset),
                    radius: bottomLeftRadius,
                    startAngle: .pi,
                    endAngle: .pi * 1.5,
                    clockwise: false)
        
        path.addArc(center: CGPoint(x: newCGSize.width - bottomRightRadius - inset,
                                    y: bottomRightRadius + inset),
                    radius: bottomRightRadius,
                    startAngle: .pi * 1.5,
                    endAngle: .pi * 2.0,
                    clockwise: false)
        
        path.addArc(center: CGPoint(x: newCGSize.width - topRightRadius - inset,
                                    y: newCGSize.height - topRightRadius - inset),
                    radius: topRightRadius,
                    startAngle: 0,
                    endAngle: .pi / 2.0,
                    clockwise: false)
        
        path.addArc(center: CGPoint(x: topLeftRadius + inset,
                                y: newCGSize.height - topLeftRadius - inset),
                    radius: topLeftRadius,
                    startAngle: .pi / 2.0,
                    endAngle: .pi,
                    clockwise: false)
        
        path.closeSubpath()
        
        ctx.setLineWidth(CGFloat(lineWidth))
        ctx.setStrokeColor(CGColor.black)
        ctx.addPath(path)
        ctx.strokePath()
        
        let newImage = ctx.makeImage()!
        
        return newImage
    }
    
    @discardableResult func write(to destinationURL: URL) -> Bool {
        guard let destination = CGImageDestinationCreateWithURL(destinationURL as CFURL, kUTTypePNG, 1, nil) else { return false }
        CGImageDestinationAddImage(destination, self, nil)
        return CGImageDestinationFinalize(destination)
    }
}
