import ChessKit

protocol MoveSelector {
    func update(position: BitBoard)

    func beginSearch(outputCallback: (String) -> (), completion: (Move?) -> ())
    func selectMove() -> Move?
}
