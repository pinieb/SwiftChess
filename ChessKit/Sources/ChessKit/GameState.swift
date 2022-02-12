public struct GameState {
    public var halfMove = 1
    public var turnToMove = Color.white
    public var castlingRights = [CastlingRights.all, CastlingRights.all]
    public var enPassant = SquareSet.none

    public var capturedPiece: Piece? = nil

    public var fiftyMoveCounter = 0

    public var next: GameState {
        var next = self
        next.turnToMove = next.turnToMove.opponent

        next.halfMove += 1
        next.fiftyMoveCounter += 1

        next.enPassant = .none
        next.capturedPiece = nil

        return next
    }
}
