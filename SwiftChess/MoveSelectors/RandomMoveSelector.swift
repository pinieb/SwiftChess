import ChessKit
import Foundation

class RandomMoveSelector: MoveSelector {
    private var moves = [Move]()
    private var position = BitBoard()

    private let evaluator: Evaluator

    required init(evaluator: Evaluator) {
        self.evaluator = evaluator
    }

    func update(position: BitBoard) {
        self.position = position
        moves = MoveGenerator.generateMoves(from: position)
    }

    func beginSearch(outputCallback: (String) -> (), completion: (Move?) -> ()) {
        var i = 1
        moves.forEach {
            position.make(move: $0)
            let score = evaluator.evaluate(position: position)
            position.unmake(move: $0)
            
            outputCallback("info score cp \(Int(score * 100)) currmove \($0.longAlgebraicNotation(color: position.turnToMove)) currmovenumber \(i)")
            i += 1
        }

        completion(selectMove())
    }

    func selectMove() -> Move? {
        guard !moves.isEmpty else { return nil }

        return moves[Int.random(in: 0 ..< moves.count)]
    }
}
