import Cocoa
import ArgumentParser

public struct OutlineImage: ParsableCommand {

    @Argument(help: Help.argument, completion: .file())
    var filePath: String
    
    // -r --radius
    @Option(name: [.customLong("radius"), .customShort("r")], help: Help.cornerRadius)
    var cornerRadius: Int = 0
    
    // -m --mask
    @Option(name: .shortAndLong, help: Help.mask)
    var mask: CornerMask
    
    // -w --width
    @Option(name: [.customLong("width"), .customShort("w")], help: Help.lineWidth)
    var lineWidth: Int = 1
    
    // -o --overwrite
    @Flag(name: [.customLong("overwrite"), .customShort("o")], help: Help.overwrite)
    var shouldOverwrite: Bool = false
    
    enum Error: String, Swift.Error {
        case invalidOrMissingImage
        case unableToExportPNG
    }
    
    public init() {
    }
    
    public func run() throws {
        
        // Load up the image
        let fileURL = URL(fileURLWithPath: filePath)
        guard let image = NSImage(contentsOf: fileURL) else { throw Error.invalidOrMissingImage }
        let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil)!
        
        // Transform the image
        let newImage = cgImage.addingOutline(mask: mask,
                                             radius: cornerRadius,
                                             width: lineWidth)
        
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
        newImage.write(to: outputURL)
    }
}
