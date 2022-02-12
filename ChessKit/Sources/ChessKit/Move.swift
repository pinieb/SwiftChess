public enum Move {
    case quiet(from: SquareSet, to: SquareSet)
    case capture(from: SquareSet, to: SquareSet)
    case enPassant(from: SquareSet, to: SquareSet)
    case castle(_ side: Castle)
    case promotion(from: SquareSet, piece: PieceType)
}

extension Move: CustomStringConvertible {
    public var description: String {
        var action = ""
        var source: SquareSet
        var target: SquareSet

        switch self {
        case let .castle(side):
            return side.notation
        case let .promotion(s, piece):
            return "\(s)=\(piece.notation)"
        case let .quiet(s, t):
            source = s
            target = t
            action = "-"
        case let .capture(s, t),
            let .enPassant(s, t):
            source = s
            target = t
            action = "x"
        }

        return "\(source)\(action)\(target)"
    }
}

public struct OldMove {
    public let source: Int
    public let target: Int

    public let isCastle: Bool

    public let capturedPiece: Piece?
    public let priorState: GameState
}
