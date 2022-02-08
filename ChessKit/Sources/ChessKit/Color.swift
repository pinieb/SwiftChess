public enum Color: Int {
     case white
     case black
     case all

    var next: Color {
        switch self {
        case .white:
            return .black
        case .black:
            return .white
        case .all:
            return .all
        }
    }
}

extension Color: CaseIterable {}
