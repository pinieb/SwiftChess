import ChessKit

protocol MoveSelector {
    init(evaluator: Evaluator)

    func update(position: BitBoard)

    func beginSearch(outputCallback: (String) -> (), completion: (Move?) -> ())
    func selectMove() -> Move?
}
