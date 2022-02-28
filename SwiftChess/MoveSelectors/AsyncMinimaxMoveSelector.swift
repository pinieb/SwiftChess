import ChessKit
import Foundation

class AsyncMinimaxMoveSelector: MoveSelector {
    private var position = BitBoard()
    private var operationQueue = OperationQueue()
    private var operations = [MinimaxOperation]()

    var moves = [Move]()
    var scoredMoves = [(move: Move, score: Double)]()

    private let evaluator: Evaluator
    private let maxDepth: Int

    init(evaluator: Evaluator,
         maxDepth: Int,
         threads: Int) {
        self.evaluator = evaluator
        self.maxDepth = maxDepth

        operationQueue.maxConcurrentOperationCount = threads
    }

    func update(position: BitBoard) {
        self.position = position
        moves = MoveGenerator.generateMoves(from: position)
    }

    public func beginSearch(outputCallback: (String) -> (),
                            completion: (Move?) -> ()) {
        operations = []

        for move in moves {
            let operation = MinimaxOperation(evaluator: evaluator,
                                             move: move,
                                             maxPly: maxDepth,
                                             position: position)
            operations.append(operation)
        }

        operationQueue.addOperations(operations,
                                     waitUntilFinished: true)
        scoredMoves = operations.compactMap {
            guard let score = $0.finalScore else { return nil }
            return ($0.move, score)
        }

        if position.turnToMove == .white {
            scoredMoves.sort { $0.1 > $1.1 }
        } else {
            scoredMoves.sort { $0.1 < $1.1 }
        }

        completion(selectMove())
    }

    func selectMove() -> Move? { scoredMoves.first?.move }
}

