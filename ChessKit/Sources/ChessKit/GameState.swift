public struct GameState {
    public var halfMove = 1
    public var turnToMove = Color.white
    public var castlingRights = [CastlingRights.all, CastlingRights.all]
    public var enPassant: Int?

    public var fiftyMoveCounter = 0
}
