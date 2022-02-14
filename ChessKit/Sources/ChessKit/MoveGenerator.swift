public class MoveGenerator {
    public static func generateMoves(from position: BitBoard) -> [Move] {
        var moves = [Move]()

        moves.append(contentsOf: pawnMoves(color: position.turnToMove,
                                           pieces: position.pieces,
                                           enPassant: position.enPassant))

        moves.append(contentsOf: knightMoves(color: position.turnToMove,
                                             pieces: position.pieces))

        moves.append(contentsOf: diagonalSliderMoves(color: position.turnToMove,
                                                     pieces: position.pieces))

        moves.append(contentsOf: orthogonalSliderMoves(color: position.turnToMove,
                                                       pieces: position.pieces))

        moves.append(contentsOf: kingMoves(color: position.turnToMove,
                                           pieces: position.pieces))

        moves.append(contentsOf: castles(color: position.turnToMove,
                                         position: position))

        var position = position
        return moves.filter { move in
            position.make(move: move)
            let isLegal = !position.pieces.isInCheck(color: position.turnToMove.opponent)
            position.unmake(move: move)

            return isLegal
        }
    }

    static func pawnMoves(color: Color,
                          pieces: PieceCollection,
                          enPassant: SquareSet) -> [Move] {
        var moves = [Move]()
        pieces[color, .pawn].forEach { source in
            moves.append(contentsOf: pawnPushes(color: color,
                                                pieces: pieces,
                                                source: source))

            moves.append(contentsOf: pawnCaptures(color: color,
                                                  pieces: pieces,
                                                  source: source))
        }

        moves.append(contentsOf: enPassantCaptures(color: color,
                                                   pieces: pieces,
                                                   enPassant: enPassant))

        return moves
    }

    private static func pawnPushes(color: Color,
                                   pieces: PieceCollection,
                                   source: SquareSet) -> [Move] {
        let shift = color == .white ? 8 : -8
        let promotionRank: SquareSet = color == .white ? .rank8 : .rank1

        let singlePush = source.shifted(by: shift)
        guard !pieces.all.contains(singlePush) else { return [] }

        var moves = [Move]()

        if promotionRank.contains(singlePush) {
            PieceType.promotions.forEach {
                moves.append(.promotion(from: source,
                                        piece: $0))
            }

            return moves
        }

        moves.append(Move.quiet(from: source,
                                to: singlePush))

        // If we're on the starting rank, we can double push
        let startingRank = color == .white ? SquareSet.rank2 : SquareSet.rank7
        guard startingRank.contains(source) else {
            return moves
        }

        let doublePush = singlePush.shifted(by: shift)
        if !pieces.all.contains(doublePush) {
            moves.append(.quiet(from: source,
                                to: doublePush))
        }

        return moves
    }

    private static func pawnCaptures(color: Color,
                                     pieces: PieceCollection,
                                     source: SquareSet) -> [Move] {
        let left = source.shifted(by: color == .white ? 7 : -9)
        let right = source.shifted(by: color == .white ? 9 : -7)

        var moves = [Move]()
        if !SquareSet.aFile.contains(source),
            pieces[color.opponent].contains(left) {
            moves.append(.capture(from: source,
                                  to: left))
        }

        if !SquareSet.hFile.contains(source),
           pieces[color.opponent].contains(right) {
            moves.append(.capture(from: source,
                                  to: right))
        }

        return moves
    }

    private static func enPassantCaptures(color: Color,
                                          pieces: PieceCollection,
                                          enPassant: SquareSet) -> [Move] {
        let left = enPassant.shifted(by: color == .white ? -9 : 7)
        let right = enPassant.shifted(by: color == .white ? -7 : 9)

        var moves = [Move]()

        if !SquareSet.aFile.contains(enPassant),
           pieces[color, .pawn].contains(left) {
            moves.append(.enPassant(from: left,
                                    to: enPassant))
        }

        if !SquareSet.hFile.contains(enPassant),
           pieces[color, .pawn].contains(right) {
            moves.append(.enPassant(from: right,
                                    to: enPassant))
        }

        return moves
    }

    private static func knightMoves(color: Color,
                                    pieces: PieceCollection) -> [Move] {
        var moves = [Move]()
        pieces[color, .knight].forEach { source in
            guard let sourceIndex = SquareIndex(rawValue: source.rawValue.first!) else {
                return
            }

            var targets = MoveSets.knight[sourceIndex.rawValue]
            targets.remove(pieces[color])

            targets.forEach { target in
                if pieces[color.opponent].contains(target) {
                    moves.append(.capture(from: source,
                                          to: target))
                } else {
                    moves.append(.quiet(from: source,
                                        to: target))
                }
            }
        }

        return moves
    }

    private static func diagonalSliderMoves(color: Color,
                                            pieces: PieceCollection) -> [Move] {
        var moves = [Move]()

        let sliders = pieces[color, .bishop].union(pieces[color, .queen])

        sliders.forEach { source in
            guard let sourceIndex = SquareIndex(rawValue: source.rawValue.first!) else {
                return
            }

            for direction in 0 ..< 4 {
                let blockedSquares = pieces.all.intersection(MoveSets.bishop[direction][sourceIndex.rawValue])

                var firstHit: Int?
                if direction < 2 {
                    firstHit = blockedSquares.rawValue.last
                } else {
                    firstHit = blockedSquares.rawValue.first
                }

                var availableSquares = MoveSets.bishop[direction][sourceIndex.rawValue]
                if let firstHit = firstHit {
                    availableSquares.remove(MoveSets.bishop[direction][firstHit])
                    availableSquares.remove(pieces[color])
                }

                availableSquares.forEach { target in
                    guard !pieces[color.opponent].contains(target) else {
                        moves.append(.capture(from: source,
                                              to: target))
                        return
                    }

                    moves.append(.quiet(from: source,
                                        to: target))
                }
            }
        }

        return moves
    }

    private static func orthogonalSliderMoves(color: Color,
                                              pieces: PieceCollection) -> [Move] {
        var moves = [Move]()

        let sliders = pieces[color, .rook].union(pieces[color, .queen])
        sliders.forEach { source in
            guard let sourceIndex = SquareIndex(rawValue: source.rawValue.first!) else {
                return
            }

            for direction in 0 ..< 4 {
                let blockedSquares = pieces.all.intersection(MoveSets.rook[direction][sourceIndex.rawValue])

                var firstHit: Int?
                if direction < 2 {
                    firstHit = blockedSquares.rawValue.first
                } else {
                    firstHit = blockedSquares.rawValue.last
                }

                var availableSquares = MoveSets.rook[direction][sourceIndex.rawValue]
                if let firstHit = firstHit {
                    availableSquares.remove(MoveSets.rook[direction][firstHit])
                    availableSquares.remove(pieces[color])
                }

                availableSquares.forEach { target in
                    guard !pieces[color.opponent].contains(target) else {
                        moves.append(.capture(from: source,
                                              to: target))
                        return
                    }

                    moves.append(.quiet(from: source,
                                        to: target))
                }
            }
        }

        return moves
    }

    public static func kingMoves(color: Color,
                                 pieces: PieceCollection) -> [Move] {
        var moves = [Move]()

        let source = pieces[color, .king]
        guard let index = source.rawValue.first else {
            return []
        }

        var targets = MoveSets.king[index]
        targets.remove(pieces[color])

        targets.forEach { target in
            if pieces[color.opponent].contains(target) {
                moves.append(.capture(from: source,
                                      to: target))
            } else {
                moves.append(.quiet(from: source,
                                    to: target))
            }
        }

        return moves
    }

    public static func castles(color: Color,
                               position: BitBoard) -> [Move] {
        guard !position.pieces.isInCheck(color: color) else { return [] }

        var moves = [Move]()

        let kingSquare: SquareSet = color == .white ? [.e1] : [.e8]
        let kingsideSquares: SquareSet = color == .white ? [.f1, .g1] : [.f8, .g8]
        let queensideSquares: SquareSet = color == .white ? [.b1, .c1, .d1] : [.b8, .c8, .d8]

        guard position.pieces[color, .king] == kingSquare else { return [] }

        let dangerSquares = position.pieces.kingDangerSquares[color]

        let canKingsideCastle = position.states.last?.castlingRights[position.turnToMove.rawValue].contains(.kingside) ?? false

        var rookSquare: SquareSet = color == .white ? [.h1] : [.h8]
        var hasRook = position.pieces[color, .rook].contains(rookSquare)
        if canKingsideCastle,
           hasRook,
           position.pieces.all.intersection(kingsideSquares) == .none,
           dangerSquares.intersection([kingSquare, kingsideSquares]) == .none {
            moves.append(.castle(.kingside))
        }

        let canQueensideCastle = position.states.last?.castlingRights[position.turnToMove.rawValue].contains(.queenside) ?? false

        rookSquare = color == .white ? [.a1] : [.a8]
        hasRook = position.pieces[color, .rook].contains(rookSquare)
        if canQueensideCastle,
           hasRook,
           position.pieces.all.intersection(queensideSquares) == .none,
           dangerSquares.intersection([kingSquare, queensideSquares]) == .none {
            moves.append(.castle(.queenside))
        }

        return moves
    }
}
