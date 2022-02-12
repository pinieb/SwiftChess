public enum PieceType: Int {
    case pawn
    case knight
    case bishop
    case rook
    case queen
    case king

    init?(from char: Character) {
        switch char.lowercased() {
        case "p":
            self = .pawn
        case "n":
            self = .knight
        case "b":
            self = .bishop
        case "r":
            self = .rook
        case "q":
            self = .queen
        case "k":
            self = .king
        default:
            return nil
        }
    }

    var notation: String {
        switch self {
        case .pawn:
            return ""
        case .knight:
            return "N"
        case .bishop:
            return "B"
        case .rook:
            return "R"
        case .queen:
            return "Q"
        case .king:
            return "K"
        }
    }
}

extension PieceType: CaseIterable {}

