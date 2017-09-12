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

enum Corner: Int {
    case topLeft = 0
    case topRight = 1
    case bottomRight = 2
    case bottomLeft = 3
}

struct Instructions {
    let roundedCorners: Set<Corner>
    let lineThickness: CGFloat
    let shouldOverwrite: Bool
    let fileURLs: [URL]
    let cornerRadius: CGFloat = 5
    
    func radius(for corner: Corner) -> CGFloat {
        return roundedCorners.contains(corner) ? cornerRadius : 0
    }
}

func corners(fromMask mask: String) -> Set<Corner> {
    guard mask.count == 4 else {
        print("Illegal rounding mask. Expected 4-bit mask.")
        printUsage()
        exit(0)
    }
    var corners: Set<Corner> = []
    for (idx,char) in mask.enumerated() {
        guard char == "1" else { continue }
        guard let corner = Corner(rawValue: idx) else {
            print("Illegal rounding mask. Expected something like 1100 for top corners or 1111 for all corners.")
            printUsage()
            exit(0)
        }
        corners.insert(corner)
    }
    return corners
}

func readArgs(_ args: [String]) -> Instructions {
    var roundedCorners: Set<Corner> = []
    var shouldOverwrite = false
    var lineThickness = 1
    var files: [String] = []
    
    var args = args// mutable copy
    args.removeFirst()
    var skipNextArg = false
    for (index,arg) in args.enumerated() {
        if skipNextArg {
            skipNextArg = false
            continue
        }
        switch arg {
        case "-r", "--rounded":
            roundedCorners = [.topLeft, .topRight, .bottomLeft, .bottomRight]
        case "-o", "--overwrite":
            shouldOverwrite = true
        case "-h", "--help":
            printUsage()
            exit(0)
        case "-m", "--rounding-mask":
            skipNextArg = true
            let mask = args[index+1]
            roundedCorners = corners(fromMask: mask)
        case "-t", "--thickness":
            skipNextArg = true
            let thicknessArg = args[index+1]
            guard let thickness = Int(thicknessArg) else {
                print("Illegal thickness. Provide an integer number of pixels.")
                printUsage()
                exit(0)
            }
            lineThickness = thickness
        default:
            files.append(arg)
        }
    }
    
    let urls = files.map { URL(fileURLWithPath: $0) }
    let instructions = Instructions(roundedCorners: roundedCorners,
                                    lineThickness: CGFloat(lineThickness),
                                    shouldOverwrite: shouldOverwrite,
                                    fileURLs: urls)
    return instructions
}


