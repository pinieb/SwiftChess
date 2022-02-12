public struct BitBoard: Board {
    var states = [GameState]()
    var pieces: PieceCollection

    var attackedSquares = [SquareSet](repeating: 0, count: 2)
    var kingDangerSquares = [SquareSet](repeating: 0, count: 2)

    var turnToMove: Color { states.last!.turnToMove }
    var enPassant: SquareSet { states.last!.enPassant }

    public init(from fen: String = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1") {
        pieces = PieceCollection()

        states.append(GameState())

        let components = fen.components(separatedBy: " ")
        let squares = components[0]

        var row = 7
        var column = 0
        for char in squares {
            guard char != "/" else {
                row -= 1
                column = 0
                continue
            }

            guard row >= 0 else { break }

            if let empty = Int(String(char)) {
                column += empty
                continue
            }

            let color = char.isUppercase ? Color.white : Color.black
            guard let piece = PieceType(from: char) else {
                break
            }

            let index = row * 8 + column
            pieces[color, piece].insert(value: 1 << index)

            column += 1
        }

        guard components.count > 1 else { return }

        states[0].turnToMove = components[1] == "w" ? .white : .black

        var castlingRights: [CastlingRights] = [.none, .none]
        for right in components[2] {
            let color = right.isUppercase ? Color.white : Color.black

            switch right.lowercased() {
            case "k":
                castlingRights[color].insert(.kingside)
            case "q":
                castlingRights[color].insert(.queenside)
            default:
                break
            }
        }

        states[0].castlingRights = castlingRights
    }

    private init(board: BitBoard) {
        pieces = board.pieces
        states = board.states
    }

    public mutating func reset() {
        states = [GameState()]

        pieces[.white, .pawn] = .rank2
        pieces[.white, .rook] = [.a1, .h1]
        pieces[.white, .knight] = [.b1, .g1]
        pieces[.white, .bishop] = [.c1, .f1]
        pieces[.white, .queen] = [.d1]
        pieces[.white, .king] = [.e1]

        pieces[.black, .pawn] = .rank7
        pieces[.black, .rook] = [.a8, .h8]
        pieces[.black, .knight] = [.b8, .g8]
        pieces[.black, .bishop] = [.c8, .f8]
        pieces[.black, .queen] = [.d8]
        pieces[.black, .king] = [.e8]
    }

    public mutating func make(move: Move) {
        var nextState: GameState

        switch move {
        case let .castle(side):
            nextState = playCastle(side: side)
        case let .promotion(source, piece):
            nextState = playPromotion(source: source,
                                      piece: piece)
        case let .enPassant(source, target):
            nextState = playEnPassant(source: source,
                                      target: target)
        case let .quiet(source, target),
            let .capture(source, target):
            nextState = playMove(source: source, target: target)
        }

        states.append(nextState)
    }

    private mutating func playCastle(side: Castle) -> GameState {
        let kingStart: SquareIndex = turnToMove == .white ? .e1 : .e8
        let kingEnd: SquareIndex
        let rookStart: SquareIndex
        let rookEnd: SquareIndex

        if side == .kingside {
            if turnToMove == .white {
                kingEnd = .g1
                rookStart = .h1
                rookEnd = .f1
            } else {
                kingEnd = .g8
                rookStart = .h8
                rookEnd = .f8
            }
        } else {
            if turnToMove == .white {
                kingEnd = .c1
                rookStart = .a1
                rookEnd = .d1
            } else {
                kingEnd = .c8
                rookStart = .a8
                rookEnd = .d8
            }
        }

        set(square: kingStart, to: nil)
        set(square: rookStart, to: nil)
        set(square: kingEnd, to: Piece(color: turnToMove,
                                       type: .king))
        set(square: rookEnd, to: Piece(color: turnToMove,
                                       type: .rook))

        var nextState = states.last!.next
        nextState.castlingRights[turnToMove] = .none

        return nextState
    }

    private mutating func playPromotion(source: SquareSet, piece: PieceType) -> GameState {
        let pawnSquare = SquareIndex(rawValue: source.rawValue.first!)!

        let direction = turnToMove == .white ? 8 : -8
        let promotionSquare = SquareIndex(rawValue: pawnSquare.rawValue + direction)!

        set(square: pawnSquare, to: nil)
        set(square: promotionSquare, to: Piece(color: turnToMove,
                                               type: piece))

        return states.last!.next
    }

    private mutating func playEnPassant(source: SquareSet, target: SquareSet) -> GameState {
        let pawnSquare = SquareIndex(rawValue: source.rawValue.first!)!

        let targetSquare = SquareIndex(rawValue: states.last!.enPassant.rawValue.first!)!

        set(square: pawnSquare, to: nil)
        set(square: targetSquare, to: Piece(color: turnToMove,
                                            type: .pawn))

        var nextState = states.last!.next
        nextState.capturedPiece = Piece(color: nextState.turnToMove,
                                        type: .pawn)

        return nextState
    }

    private mutating func playMove(source: SquareSet, target: SquareSet) -> GameState {
        let piece = getPiece(at: source)!

        let sourceSquare = SquareIndex(rawValue: source.rawValue.first!)!
        let targetSquare = SquareIndex(rawValue: target.rawValue.first!)!

        var nextState = states.last!.next

        if let capturedPiece = getPiece(at: targetSquare.rawValue) {
            nextState.capturedPiece = capturedPiece
        }

        set(square: sourceSquare, to: nil)
        set(square: targetSquare, to: piece)

        return nextState
    }

    mutating func make(move: OldMove) {
        guard let moving = getPiece(at: move.source) else {
            return
        }

//        set(square: move.source, to: nil)
//        set(square: move.target, to: moving)
//
        var state = states.last ?? GameState()
//
//        if move.isCastle {
//            if move.target - move.source > 0 {
//                set(square: moving.color == .white ? 7 : 63,
//                    to: nil)
//                set(square: move.target - 1,
//                    to: Piece(color: moving.color,
//                              type: .rook))
//            } else {
//                set(square: moving.color == .white ? 0 : 56,
//                    to: nil)
//                set(square: move.target + 1,
//                    to: Piece(color: moving.color,
//                              type: .rook))
//            }
//        }

        if moving.type == .pawn || move.capturedPiece != nil {
            state.fiftyMoveCounter = 0
        }

        state.fiftyMoveCounter += 1

        if moving.type == .king {
            state.castlingRights[moving.color] = .none
        }

        if moving.type == .rook, (move.source == 0 || move.source == 56) {
            state.castlingRights[moving.color].remove(.queenside)
        }

        if moving.type == .rook, (move.source == 7 || move.source == 63) {
            state.castlingRights[moving.color].remove(.kingside)
        }

        state.turnToMove = state.turnToMove.opponent

        states.append(state)
    }

    mutating func unmake(move: OldMove) {
        precondition(states.count > 1,
                     "Cannot undo a move from the starting position")

        guard let moving = getPiece(at: move.target) else {
            return
        }

//        set(square: move.target, to: move.capturedPiece)
//        set(square: move.source, to: moving)
//
//        if move.isCastle {
//            if move.target - move.source > 0 {
//                set(square: moving.color == .white ? 7 : 63,
//                    to: Piece(color: moving.color,
//                              type: .rook))
//                set(square: move.target - 1,
//                    to: nil)
//            } else {
//                set(square: moving.color == .white ? 0 : 56,
//                    to: Piece(color: moving.color,
//                              type: .rook))
//                set(square: move.target + 1,
//                    to: nil)
//            }
//        }
//
//        states.removeLast()
    }

    func isInCheck(color: Color) -> Bool {
        attackedSquares[color].intersection(pieces[color, .king]) != .none
    }

    mutating func set(square: SquareIndex, to piece: Piece?) {
        let squareSet = SquareSet(index: square)
        pieces.clear(squares: squareSet)

        if let piece = piece {
            pieces[piece].insert(squareSet)
        }
    }

    public func getPiece(at square: SquareSet) -> Piece? {
        guard let index = square.rawValue.first else { return nil }
        return getPiece(at: index)
    }

    public func getPiece(at square: Int) -> Piece? {
        guard let square = SquareIndex(rawValue: square) else { return nil }

        return pieces[square]
    }

    public func getMoves(from square: Int) -> [OldMove] {
        guard let piece = getPiece(at: square) else {
            return []
        }

        var moves: [OldMove]
        switch piece.type {
        case .pawn:
            moves = movesForPawn(at: square,
                                 of: piece.color)
        case .knight:
            moves = movesForKnight(at: square,
                                   of: piece.color)
        case .bishop:
            moves = movesForBishop(at: square,
                                   of: piece.color)
        case .rook:
            moves = movesForRook(at: square,
                                 of: piece.color)
        case .queen:
            moves = movesForBishop(at: square,
                                   of: piece.color) +
             movesForRook(at: square,
                          of: piece.color)
        case .king:
            moves = movesForKing(at: square,
                                 for: piece.color)
        }

        return moves
    }

    public func possibleMoves(for color: Color) -> [OldMove] {
        var moves = [OldMove]()
        
        moves.append(contentsOf: possiblePawnMoves(for: color))
        moves.append(contentsOf: possibleKnightMoves(for: color))
        moves.append(contentsOf: possibleBishopMoves(for: color))
        moves.append(contentsOf: possibleRookMoves(for: color))
        moves.append(contentsOf: possibleQueenMoves(for: color))
        moves.append(contentsOf: possibleKingMoves(for: color))

        return moves
    }

    private func possiblePawnMoves(for color: Color) -> [OldMove] {
        let pawns = pieces[color, .pawn]

        var moves = [OldMove]()
        pawns.rawValue.forEach { source in
            moves.append(contentsOf: movesForPawn(at: source,
                                                  of: color))
        }

        return moves
    }

    private func movesForPawn(at square: Int, of color: Color) -> [OldMove] {
        var moves = [OldMove]()

        Moves.pawnMoves[color][square].forEach { target in
            guard getPiece(at: target) == nil else { return }

            let move = OldMove(source: square,
                            target: target,
                            isCastle: false,
                            capturedPiece: nil,
                               priorState: states.last!)

            moves.append(move)
        }

        // TODO: check for captures and en passant

        return moves
    }

    private func possibleKnightMoves(for color: Color) -> [OldMove] {
        let knights = pieces[color, .knight]

        var moves = [OldMove]()
        knights.rawValue.forEach { square in
            moves.append(contentsOf: movesForKnight(at: square,
                                                    of: color))
        }

        return moves
    }

    private func movesForKnight(at square: Int, of color: Color) -> [OldMove] {
        var moves = [OldMove]()

        Moves.knightMoves[square].forEach { target in
            let targetOccupant = getPiece(at: target)
            guard targetOccupant?.color != color else { return }

            let move = OldMove(source: square,
                            target: target,
                            isCastle: false,
                            capturedPiece: targetOccupant,
                            priorState: states.last!)

            moves.append(move)
        }

        return moves
    }

    private func possibleBishopMoves(for color: Color) -> [OldMove] {
        let bishops = pieces[color, .bishop]

        var moves = [OldMove]()
        bishops.rawValue.forEach { square in
            moves.append(contentsOf: movesForBishop(at: square,
                                                    of: color))
        }

        return moves
    }

    private func movesForBishop(at square: Int, of color: Color) -> [OldMove] {
        var moves = [OldMove]()

        for direction in 0 ..< 4 {
            let blockedSquares = pieces.all.rawValue & Moves.bishopMoves[direction][square]

            var firstHit: Int?
            if direction < 2 {
                firstHit = blockedSquares.first
            } else {
                firstHit = blockedSquares.last
            }

            var availableSquares = Moves.bishopMoves[direction][square]
            if let firstHit = firstHit {
                availableSquares ^= Moves.bishopMoves[direction][firstHit]
            }

            availableSquares.forEach { target in
                let targetOccupant = getPiece(at: target)
                guard targetOccupant?.color != color else { return }

                let move = OldMove(source: square,
                                target: target,
                                isCastle: false,
                                capturedPiece: targetOccupant,
                                priorState: states.last!)

                moves.append(move)
            }
        }

        return moves
    }

    private func possibleRookMoves(for color: Color) -> [OldMove] {
        let rooks = pieces[color, .rook]

        var moves = [OldMove]()
        rooks.rawValue.forEach { square in
            moves.append(contentsOf: movesForRook(at: square,
                                                  of: color))
        }

        return moves
    }

    private func movesForRook(at square: Int, of color: Color) -> [OldMove] {
        var moves = [OldMove]()
        for direction in 0 ..< 4 {
            let blockedSquares = pieces.all.rawValue & Moves.rookMoves[direction][square]

            var firstHit: Int?
            if direction < 2 {
                firstHit = blockedSquares.first
            } else {
                firstHit = blockedSquares.last
            }

            var availableSquares = Moves.rookMoves[direction][square]
            if let firstHit = firstHit {
                availableSquares ^= Moves.rookMoves[direction][firstHit]
            }

            availableSquares.forEach { target in
                let targetOccupant = getPiece(at: target)
                guard targetOccupant?.color != color else { return }

                let move = OldMove(source: square,
                                target: target,
                                isCastle: false,
                                capturedPiece: targetOccupant,
                                priorState: states.last!)

                moves.append(move)
            }
        }

        return moves
    }

    private func possibleQueenMoves(for color: Color) -> [OldMove] {
        let queens = pieces[color, .queen]

        var moves = [OldMove]()
        queens.rawValue.forEach { square in
            moves.append(contentsOf: movesForBishop(at: square,
                                                    of: color))
            moves.append(contentsOf: movesForRook(at: square,
                                                  of: color))
        }

        return moves
    }

    private func possibleKingMoves(for color: Color) -> [OldMove] {
        let kings = pieces[color, .king]

        var moves = [OldMove]()
        kings.rawValue.forEach { square in
            moves.append(contentsOf: movesForKing(at: square,
                                                  for: color))
        }

        return moves
    }

    private func movesForKing(at square: Int, for color: Color) -> [OldMove] {
        var moves = [OldMove]()

        Moves.kingMoves[square].forEach { target in
            let targetOccupant = getPiece(at: target)
            guard targetOccupant?.color != color else { return }

            // TODO: Make sure move doesn't end in check

            let move = OldMove(source: square,
                            target: target,
                            isCastle: false,
                            capturedPiece: targetOccupant,
                            priorState: states.last!)

            moves.append(move)
        }

        // TODO: Check castling

        return moves
    }

    private func castles(for color: Color) -> [OldMove] {
        return []
    }

    public func printTargets(_ targets: Int, from square: Int) {
        for row in (0 ..< 8).reversed() {
            var line = ""
            for col in 0 ..< 8 {
                guard row * 8 + col != square else {
                    line.append("X")
                    continue
                }

                line.append(targets[row * 8 + col] ? "1" : "0")
            }

            print(line)
        }
    }
}

extension BitBoard: CustomStringConvertible {
    public var description: String {
        var lines = [String]()
        let divider = "  +---+---+---+---+---+---+---+---+"
        lines.append(divider)

        var row = ""
        for square in (0 ..< 64).reversed() {
            let piece = getPiece(at: square)?.description ?? " "
            row = " \(piece) |" + row

            if (square) % 8 == 0 {
                lines.append("\(square / 8 + 1) |" + row)
                lines.append(divider)
                row = ""
            }
        }

        lines.append("    a   b   c   d   e   f   g   h")

        return lines.joined(separator: "\n")
    }
}
