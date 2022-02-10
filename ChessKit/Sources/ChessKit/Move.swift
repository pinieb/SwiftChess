public enum Move {
    case quiet(from: SquareSet, to: SquareSet)
    case capture(from: SquareSet, to: SquareSet)
    case enPassant(from: SquareSet, to: SquareSet)
    case castle(_ side: Castle)
    case promotion(from: SquareSet, piece: PieceType)
}

public struct OldMove {
    public let source: Int
    public let target: Int

    public let isCastle: Bool

    public let capturedPiece: Piece?
    public let priorState: GameState
}
