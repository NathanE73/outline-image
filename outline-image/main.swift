
import Cocoa
import ArgumentParser

struct OutlineImage: ParsableCommand {

    @Argument(help: Help.argument, completion: .file())
    var filePath: String
    
    @Option(name: [.customLong("radius"), .customShort("r")], help: Help.cornerRadius)
    var cornerRadius: Double = 0
    
    @Option(name: .shortAndLong, help: Help.mask)
    var mask: CornerMask
    
    @Option(name: [.customLong("width"), .customShort("w")], help: Help.lineWidth)
    var lineWidth: Double = 1
    
    @Flag(name: [.customLong("overwrite"), .customShort("o")])
    var shouldOverwrite: Bool = false
    
    enum Error: String, Swift.Error {
        case invalidOrMissingImage
        case unableToExportPNG
    }
    
    func run() throws {
        
        // Load up the image
        let fileURL = URL(fileURLWithPath: filePath)
        guard let image = NSImage(contentsOf: fileURL) else { throw Error.invalidOrMissingImage }
        
        // Transform the image
        let newImage = image.addingOutline(mask: mask,
                                           radius: CGFloat(cornerRadius),
                                           width: CGFloat(lineWidth))
        
        // Figure out where to save the image (overwrite or append "_outlined"?)
        let outputURL: URL
        if shouldOverwrite {
            outputURL = fileURL
        } else {
            var newURL = fileURL.deletingPathExtension()
            let name = newURL.lastPathComponent
            newURL.deleteLastPathComponent()
            newURL.appendPathComponent("\(name)_outlined")
            newURL.appendPathExtension("png")
            outputURL = newURL
        }
        
        // Save the image
        let cgImage = newImage.cgImage(forProposedRect: nil, context: nil, hints: nil)!
        let newRep = NSBitmapImageRep(cgImage: cgImage)
        newRep.size = image.size // if you want the same size
        guard let pngData = newRep.representation(using: .png, properties: [:]) else { throw Error.unableToExportPNG }
        try pngData.write(to: outputURL)
    }
}

OutlineImage.main()
