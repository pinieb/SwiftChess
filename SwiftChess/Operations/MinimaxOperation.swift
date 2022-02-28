import Foundation
import ChessKit

final class MinimaxOperation: Operation {
    let evaluator: Evaluator
    let maxPly: Int
    let move: Move
    var position: BitBoard

    public private(set) var finalScore: Double?

    init(evaluator: Evaluator,
         move: Move,
         maxPly: Int,
         position: BitBoard) {
        self.evaluator = evaluator
        self.move = move
        self.maxPly = maxPly
        self.position = position

        super.init()
    }

    override func main() {
        guard !isCancelled else { return }

        self.position.make(move: move)
        let newMoves = MoveGenerator.generateMoves(from: position)

        let score = minimax(moves: newMoves,
                            depth: maxPly)

        guard !isCancelled else { return }
        finalScore = score
    }

    private func minimax(moves: [Move], depth: Int) -> Double {
        guard depth > 1, !moves.isEmpty else {
            return evaluator.evaluate(position: position,
                                      moves: moves)
        }

        var bestScore = position.turnToMove == .white ? -Double.infinity : Double.infinity

        for move in moves {
            if isCancelled { return bestScore }

            position.make(move: move)

            let newMoves = MoveGenerator.generateMoves(from: position)
            let score = minimax(moves: newMoves, depth: depth - 1)

            position.unmake(move: move)

            if position.turnToMove == .white {
                bestScore = max(bestScore, score)
            } else {
                bestScore = min(bestScore, score)
            }
        }

        return bestScore
    }
}
