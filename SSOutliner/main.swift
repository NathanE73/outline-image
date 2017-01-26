//
//  main.swift
//  SSOutliner
//
//  Created by Michael L. Ward on 1/26/17.
//  Copyright © 2017 Michael L. Ward. All rights reserved.
//

import Cocoa

let args = ProcessInfo().arguments
guard args.count > 1 else {
    printUsage()
    exit(EXIT_FAILURE)
}

let shouldRound = args.contains("-r") || args.contains("--rounded")
let cornerRadius: CGFloat = shouldRound ? 7.0 : 0.0

var url = URL(fileURLWithPath: args[0])
url.deleteLastPathComponent()
url.appendPathComponent("\(args.last!)")

guard let img = NSImage(contentsOf: url) else {
    print("Can't load image at \(url)")
    exit(EXIT_FAILURE)
}

let newImg = img.addingOutline(thickness: 1,
                               color: NSColor.black,
                               cornerRadius: cornerRadius)
let pngData = newImg.PNGRepresentation
try! pngData.write(to: url)
