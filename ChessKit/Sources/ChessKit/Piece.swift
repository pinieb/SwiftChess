public struct Piece {
    let color: Color
    let type: PieceType
}

extension Piece: CustomStringConvertible {
    public var description: String {
        switch (color, type) {
        case (.white, .pawn):
            return "♙"
        case (.white, .knight):
            return "♘"
        case (.white, .bishop):
            return "♗"
        case (.white, .rook):
            return "♖"
        case (.white, .queen):
            return "♕"
        case (.white, .king):
            return "♔"

        case (.black, .pawn):
            return "♟︎"
        case (.black, .knight):
            return "♞"
        case (.black, .bishop):
            return "♝"
        case (.black, .rook):
            return "♜"
        case (.black, .queen):
            return "♛"
        case (.black, .king):
            return "♚"

        default:
            return "?"
        }
    }
}
