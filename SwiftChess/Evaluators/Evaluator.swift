import ChessKit

protocol Evaluator {
    func evaluate(position: BitBoard) -> Double
}
