import ChessKit

class BasicEvaluator: Evaluator {
    let pieceScores: [PieceType : Double] = [
        .king: 200.0,
        .queen: 9.0,
        .rook: 5.0,
        .bishop: 3.0,
        .knight: 3.0,
        .pawn: 1.0,
    ]

    public func evaluate(position: BitBoard) -> Double {
        //let colorMultiplier = position.turnToMove == .white ? 1.0 : -1.0

        var score = 0.0

        score += materialScore(position: position)
        score += mobilityScore(position: position)

        return score //* colorMultiplier
    }

    func materialScore(position: BitBoard) -> Double {
        var score = 0.0

        for piece in PieceType.allCases {
            let count = position.pieces[.white, piece].count() - position.pieces[.black, piece].count()
            score += pieceScores[piece, default: 0.0] * Double(count)
        }

        return score
    }

    func mobilityScore(position: BitBoard) -> Double {
        var score = 0.0

        let whiteMoves = position.pieces.attackedSquares[Color.white].count()
        let blackMoves = position.pieces.attackedSquares[Color.black].count()

        score += 0.1 * Double(whiteMoves - blackMoves)

        return score
    }
}
