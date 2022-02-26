import ChessKit

class GreedyMoveSelector: MoveSelector {
    private var moves = [Move]()
    private var scoredMoves = [(Move, Double)]()
    private var position = BitBoard()

    private let evaluator: Evaluator

    required init(evaluator: Evaluator) {
        self.evaluator = evaluator
    }

    func update(position: BitBoard) {
        self.position = position
        moves = MoveGenerator.generateMoves(from: position)
        scoredMoves = []
    }

    func beginSearch(outputCallback: (String) -> (),
                     completion: (Move?) -> ()) {
        for move in moves {
            position.make(move: move)
            let newMoves = MoveGenerator.generateMoves(from: position)
            let score = evaluator.evaluate(position: position, moves: newMoves)
            position.unmake(move: move)

            scoredMoves.append((move, score))
        }

        completion(selectMove())
    }

    func selectMove() -> Move? {
        guard !scoredMoves.isEmpty else { return nil }

        if position.turnToMove == .white {
            scoredMoves.sort { $0.1 > $1.1 }
        } else {
            scoredMoves.sort { $0.1 < $1.1 }
        }
        
        var bestMoves = scoredMoves.filter { $0.1 == scoredMoves.first!.1 }
        bestMoves.shuffle()

        return bestMoves.first?.0
    }
}
