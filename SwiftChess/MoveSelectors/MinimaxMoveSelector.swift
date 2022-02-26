import ChessKit
import QuartzCore

class MinimaxMoveSelector: MoveSelector {
    private var position = BitBoard()

    private let maxDepth: Int
    private let evaluator: Evaluator

    init(evaluator: Evaluator, maxDepth: Int) {
        self.evaluator = evaluator
        self.maxDepth = maxDepth
    }

    func update(position: BitBoard) {
        self.position = position
        moves = MoveGenerator.generateMoves(from: position)
        scoredMoves = moves.map { ($0, 0.0) }
    }

    var moves = [Move]()
    var bestMove: (move: Move, score: Double)?
    var startTime = CACurrentMediaTime()

    var scoredMoves = [(move: Move, score: Double)]()
    public func beginSearch(outputCallback: (String) -> (), completion: (Move?) -> ()) {
        scoredMoves = minimax(moves: moves, depth: maxDepth)

        completion(selectMove())
    }

    private func minimax(moves: [Move], depth: Int) -> [(move: Move, score: Double)] {
        var scoredMoves = [(move: Move, score: Double)]()

        for move in moves {
            position.make(move: move)

            var score: Double?
            
            let newMoves = MoveGenerator.generateMoves(from: position)
            if depth > 1, !newMoves.isEmpty {
                score = minimax(moves: newMoves, depth: depth - 1)[0].score
            }

            if score == nil {
                score = evaluator.evaluate(position: position, moves: newMoves)
            }

            scoredMoves.append((move, score!))
            position.unmake(move: move)
        }

        if position.turnToMove == .white {
            scoredMoves.sort { $0.1 > $1.1 }
        } else {
            scoredMoves.sort { $0.1 < $1.1 }
        }

        return scoredMoves
    }

    func selectMove() -> Move? { scoredMoves.first?.move }
}
