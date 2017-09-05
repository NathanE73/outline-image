//
//  helpers.swift
//  SSOutliner
//
//  Created by Michael L. Ward on 1/26/17.
//  Copyright © 2017 Michael L. Ward. All rights reserved.
//

import Foundation

func printUsage() {
    print("""
    usage: ssoutliner [-r] [-o] files...
    flags:
      -r, --rounded
          Round the corners. Suitable for window screenshots.
      -o, --overwrite
          Overwrite the input file.
          Otherwise, output is written to originalfilename_ssoutlined.png.
      -h, --help
          Display this help information and exit.
    """)
}


struct Instructions {
    let shouldRound: Bool
    let shouldOverwrite: Bool
    let fileURLs: [URL]
}


func readArgs(_ args: [String]) -> Instructions {
    var shouldRound = false
    var shouldOverwrite = false
    var files: [String] = []
    
    var args = args
    _ = args.removeFirst() // eat the process name
    
    while !args.isEmpty {
        guard let thing = args.popLast() else { continue }
        if thing.contains("-r") || thing.contains("--rounded") {
            shouldRound = true
            continue
        }
        if thing.contains("-o") || thing.contains("--overwrite") {
            shouldOverwrite = true
            continue
        }
        if thing.contains("-h") || thing.contains("--help") {
            printUsage()
            exit(0)
        }
        files.append(thing)
    }
    
    return Instructions(shouldRound: shouldRound,
                        shouldOverwrite: shouldOverwrite,
                        fileURLs: files.map { URL(fileURLWithPath: $0) } )
}


