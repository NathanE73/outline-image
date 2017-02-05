//
//  main.swift
//  SSOutliner
//
//  Created by Michael L. Ward on 1/26/17.
//  Copyright © 2017 Michael L. Ward. All rights reserved.
//

import Cocoa

// Read args (super-naive, ugh)
let args = ProcessInfo().arguments
guard args.count > 1 else {
    printUsage()
    exit(EXIT_FAILURE)
}
let shouldRound = args.contains("-r") || args.contains("--rounded")
let cornerRadius: CGFloat = shouldRound ? 5.0 : 0.0
var url = URL(fileURLWithPath: args.last!)
guard let img = NSImage(contentsOf: url) else {
    print("Can't load image at \(url)")
    exit(EXIT_FAILURE)
}

// Add the outline
let newImg = img.addingOutline(thickness: 1,
                               color: NSColor.black,
                               cornerRadius: cornerRadius)

// Save outlined image
let pngData = newImg.PNGRepresentation
var newURL = url.deletingPathExtension()
let name = newURL.lastPathComponent
newURL.deleteLastPathComponent()
newURL.appendPathComponent("\(name)_ssoutlined")
newURL.appendPathExtension("png")
try! pngData.write(to: newURL)
