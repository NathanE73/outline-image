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
    usage:
      ssoutliner [-r] [-o] [-c XXXX]  files...
    flags:
      -o, --overwrite
          Overwrite the input file.
          Otherwise, output is written to originalfilename_outlined.png.
      -c XXXX, --corner-mask XXXX
          Round the specified corners, where XXXX is a 4-bit binary mask indicating the corners to round.
          The digits represent the corners: Top Left, Top Right, Bottom Right, Bottom Left.
          A 1 means to round the potsitional corner, 0 means to leave it alone.
          The unquoted strings "top" and "all" are acceptable substitutes for 1100 and 1111 respectively.
          This option is designed for window screenshots.
          Without this option, all four corners will be un-rounded.
      -r, --retina
          Adjust line thickness and rounded corner radius for
      -h, --help
          Display this help information and exit.
    example:
      ssoutliner -r -c 0010 screenshot1.png screenshot2.png
          screen.png and screen2.png will both be outlined,
          rounding only the bottom-right corner,
          with retina-screenshot-optimized lines,
          and the output will be written to screen_outlined.png and screen2_outlined.png.
    """)
}

enum Corner: Int {
    case topLeft = 0
    case topRight = 1
    case bottomRight = 2
    case bottomLeft = 3
}

struct Options {
    let roundedCorners: Set<Corner>
    let cornerRadius: CGFloat
    let lineThickness: CGFloat
    let shouldOverwrite: Bool
    let fileURLs: [URL]

    func radius(for corner: Corner) -> CGFloat {
        return roundedCorners.contains(corner) ? cornerRadius : 0
    }
}

func corners(fromMask mask: String) -> Set<Corner> {
    switch mask {
    case "all":
        return [.topLeft, .topRight, .bottomLeft, .bottomRight]
    case "top":
        return [.topLeft, .topRight]
    default:
        break
    }
    guard mask.count == 4 else {
        print("Illegal rounding mask. Expected 4-bit binary mask like 1100 for top corners or 1111 for all corners.")
        printUsage()
        exit(0)
    }
    var corners: Set<Corner> = []
    for (idx,char) in mask.enumerated() {
        guard char == "1" else { continue }
        guard let corner = Corner(rawValue: idx) else {
            print("Illegal rounding mask. Expected 4-bit binary mask like 1100 for top corners or 1111 for all corners.")
            printUsage()
            exit(0)
        }
        corners.insert(corner)
    }
    return corners
}

func readArgs(_ args: [String]) -> Options {
    var roundedCorners: Set<Corner> = []
    var shouldOverwrite = false
    var lineThickness: CGFloat = 1
    var cornerRadius: CGFloat = 7
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
        case "-r", "--retina":
            lineThickness = 2
            cornerRadius = 14
        case "-o", "--overwrite":
            shouldOverwrite = true
        case "-h", "--help":
            printUsage()
            exit(0)
        case "-c", "--corner-mask":
            skipNextArg = true
            let mask = args[index+1]
            roundedCorners = corners(fromMask: mask)
        default:
            files.append(arg)
        }
    }
    
    let urls = files.map { URL(fileURLWithPath: $0) }
    let options = Options(roundedCorners: roundedCorners,
                            cornerRadius: cornerRadius,
                            lineThickness: lineThickness,
                            shouldOverwrite: shouldOverwrite,
                            fileURLs: urls)
    return options
}


