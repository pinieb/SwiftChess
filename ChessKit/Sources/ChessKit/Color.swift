public enum Color: Int {
     case white
     case black

    public var opponent: Color {
        switch self {
        case .white:
            return .black
        case .black:
            return .white
        }
    }
}

extension Color: CaseIterable {}
