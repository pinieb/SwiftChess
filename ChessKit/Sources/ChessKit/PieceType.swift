public enum PieceType: Int {
    case pawn
    case knight
    case bishop
    case rook
    case queen
    case king
    case all

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
}

extension PieceType: CaseIterable {}
