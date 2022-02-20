import ChessKit
import QuartzCore

class IterativeDFSMoveSelector: MoveSelector {
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
    }

    var moves = [Move]()
    var bestMove: (move: Move, score: Double)?
    var startTime = CACurrentMediaTime()
    func beginSearch(outputCallback: (String) -> (), completion: (Move?) -> ()) {
        var nodes = 0
        bestMove = nil
        startTime = CACurrentMediaTime()

        for move in moves {
            let result = dfs(move: move, depth: maxDepth)
            nodes += result.nodes

            if (bestMove?.score ?? -Double.infinity) < -result.score {
                bestMove = (move: move, score: -result.score)
            }

            let timeElapsed = CACurrentMediaTime() - startTime
            outputCallback("info nps \(Double(nodes) / timeElapsed)")
        }

        completion(selectMove())
    }

    private func dfs(move: Move, depth: Int) -> (nodes: Int, score: Double) {
        position.make(move: move)
        defer { position.unmake(move: move) }

        guard depth > 0 else {
            return (1, evaluator.evaluate(position: position))
        }

        let newMoves = MoveGenerator.generateMoves(from: position)
        guard !newMoves.isEmpty else {
            // TODO: check for mates
            return (1, evaluator.evaluate(position: position))
        }

        var nodes = 0
        var bestScore = -Double.infinity
        for move in newMoves {
            let result = dfs(move: move, depth: depth - 1)
            nodes += result.nodes
            bestScore = max(bestScore, -result.score)
        }

        return (nodes, bestScore)
    }

    func selectMove() -> Move? { bestMove?.move }
}
