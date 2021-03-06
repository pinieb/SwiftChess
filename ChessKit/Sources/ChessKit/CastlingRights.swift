public enum Castle {
    case kingside
    case queenside

    public var notation: String {
        switch self {
        case .kingside: return "O-O"
        case .queenside: return "O-O-O"
        }
    }
}

public struct CastlingRights: OptionSet {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let kingside = CastlingRights(rawValue: 1 << 0)
    public static let queenside = CastlingRights(rawValue: 1 << 1)

    public static let all: CastlingRights = [.kingside, .queenside]
    public static let none: CastlingRights = []
}
