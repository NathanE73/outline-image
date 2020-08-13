import Foundation
import ArgumentParser

struct CornerMask: ExpressibleByArgument, OptionSet {
    
    let rawValue: Int
    
    init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    static let topLeft = CornerMask(rawValue: 1 << 0)
    static let topRight = CornerMask(rawValue: 1 << 1)
    static let bottomRight = CornerMask(rawValue: 1 << 2)
    static let bottomLeft = CornerMask(rawValue: 1 << 3)
    
    init?(argument: String) {
        guard argument.count == 4 else { return nil }
        var mask = CornerMask(rawValue: 0)
        for char in argument.enumerated() {
            switch char.element {
            case "0": break
            case "1": mask.formUnion(CornerMask(rawValue: 1 << char.offset))
            default: return nil
            }
        }
        self.rawValue = mask.rawValue
    }
}
