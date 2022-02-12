public enum SquareIndex: Int {
    case a1, b1, c1, d1, e1, f1, g1, h1
    case a2, b2, c2, d2, e2, f2, g2, h2
    case a3, b3, c3, d3, e3, f3, g3, h3
    case a4, b4, c4, d4, e4, f4, g4, h4
    case a5, b5, c5, d5, e5, f5, g5, h5
    case a6, b6, c6, d6, e6, f6, g6, h6
    case a7, b7, c7, d7, e7, f7, g7, h7
    case a8, b8, c8, d8, e8, f8, g8, h8
}

extension SquareIndex: CaseIterable {}

extension SquareIndex: CustomStringConvertible {
    public var description: String {
        switch self {
        case .a1:
            return "a1"
        case .b1:
            return "b1"
        case .c1:
            return "c1"
        case .d1:
            return "d1"
        case .e1:
            return "e1"
        case .f1:
            return "f1"
        case .g1:
            return "g1"
        case .h1:
            return "h1"
        case .a2:
            return "a2"
        case .b2:
            return "b2"
        case .c2:
            return "c2"
        case .d2:
            return "d2"
        case .e2:
            return "e2"
        case .f2:
            return "f2"
        case .g2:
            return "g2"
        case .h2:
            return "h2"
        case .a3:
            return "a3"
        case .b3:
            return "b3"
        case .c3:
            return "c3"
        case .d3:
            return "d3"
        case .e3:
            return "e3"
        case .f3:
            return "f3"
        case .g3:
            return "g3"
        case .h3:
            return "h3"
        case .a4:
            return "a4"
        case .b4:
            return "b4"
        case .c4:
            return "c4"
        case .d4:
            return "d4"
        case .e4:
            return "e4"
        case .f4:
            return "f4"
        case .g4:
            return "g4"
        case .h4:
            return "h4"
        case .a5:
            return "a5"
        case .b5:
            return "b5"
        case .c5:
            return "c5"
        case .d5:
            return "d5"
        case .e5:
            return "e5"
        case .f5:
            return "f5"
        case .g5:
            return "g5"
        case .h5:
            return "h5"
        case .a6:
            return "a6"
        case .b6:
            return "b6"
        case .c6:
            return "c6"
        case .d6:
            return "d6"
        case .e6:
            return "e6"
        case .f6:
            return "f6"
        case .g6:
            return "g6"
        case .h6:
            return "h6"
        case .a7:
            return "a7"
        case .b7:
            return "b7"
        case .c7:
            return "c7"
        case .d7:
            return "d7"
        case .e7:
            return "e7"
        case .f7:
            return "f7"
        case .g7:
            return "g7"
        case .h7:
            return "h7"
        case .a8:
            return "a8"
        case .b8:
            return "b8"
        case .c8:
            return "c8"
        case .d8:
            return "d8"
        case .e8:
            return "e8"
        case .f8:
            return "f8"
        case .g8:
            return "g8"
        case .h8:
            return "h8"
        }
    }
}
