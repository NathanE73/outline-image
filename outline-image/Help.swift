import Foundation
import ArgumentParser

enum Help {
    static let argument = ArgumentHelp("Image file to which the outline will be applied",
                                       discussion: "The file should be in one of the standard macOS image formats including TIFF, JPEG, GIF, PNG, and PDF.")
    
    static let mask = ArgumentHelp("A four-digit boolean mask, such as 0011, to specify which corners should be rounded.",
                                   discussion: "The first digit represents the top-left corner and the remaining digits represent the next three corners, moving clockwise around the rectangle.")
    
    static let cornerRadius = ArgumentHelp("The radius of the circle which will be used to inscribe the corner which is rounded.",
                                           discussion: "This argument is ignored if no corners have been selected for rounding in the mask.",
                                           valueName: "px")
    
    static let lineWidth = ArgumentHelp("The width, in pixels, of the outline to draw.",
                                        valueName: "px")
    
    static let overwrite = ArgumentHelp("If enabled, the source file will be replaced with the tool's output. Otherwise, the tool will output the new image at <file_path>_outlined.png.")
}
