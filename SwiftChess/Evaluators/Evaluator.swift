import ChessKit

protocol Evaluator {
    func evaluate(position: BitBoard, moves: [Move]) -> Double
}
