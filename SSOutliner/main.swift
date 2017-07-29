//
//  main.swift
//  SSOutliner
//
//  Created by Michael L. Ward on 1/26/17.
//  Copyright © 2017 Michael L. Ward. All rights reserved.
//

import Cocoa


let args = ProcessInfo().arguments

// Show usage if they run without any arguments.
guard args.count > 1 else {
    printUsage()
    exit(EXIT_FAILURE)
}

let instructions = readArgs(args)

let cornerRadius: CGFloat = instructions.shouldRound ? 5.0 : 0.0

for url in instructions.fileURLs {
    guard let img = NSImage(contentsOf: url) else {
        print("Can't load image at \(url)")
        continue
    }
    
    // Add the outline
    let newImg = img.addingOutline(thickness: 1,
                                   color: NSColor.black,
                                   cornerRadius: cornerRadius)
    
    // Save outlined image
    let writeURL: URL
    
    if instructions.shouldOverwrite {
        writeURL = url
    } else {
        var newURL = url.deletingPathExtension()
        let name = newURL.lastPathComponent
        newURL.deleteLastPathComponent()
        newURL.appendPathComponent("\(name)_ssoutlined")
        newURL.appendPathExtension("png")
        writeURL = newURL
    }
    
    let pngData = newImg.PNGRepresentation
    try! pngData.write(to: writeURL)
}

