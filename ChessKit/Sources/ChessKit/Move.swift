public enum Move {
    case quiet(from: Square, to: Square)
    case capture(from: Square, to: Square)
    case castle(_ side: Castle)
    case promotion(from: Square, piece: PieceType)
}

public struct OldMove {
    public let source: Int
    public let target: Int

    public let isCastle: Bool

    public let capturedPiece: Piece?
    public let priorState: GameState
}
