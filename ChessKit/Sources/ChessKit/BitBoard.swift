public struct BitBoard: Board {
    var pieces: [[Int]]

    var states = [GameState]()

    public init(from fen: String = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1") {
        pieces = [[Int]](repeating: [Int](repeating: 0,
                                          count: PieceType.all.rawValue + 1),
                         count: Color.all.rawValue + 1)

        var state = GameState()

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

            pieces[color][piece][index] = true
            pieces[Color.all][piece][index] = true
            pieces[color][PieceType.all][index] = true
            pieces[Color.all][PieceType.all][index] = true

            column += 1
        }

        guard components.count > 1 else { return }

        state.turnToMove = components[1] == "w" ? .white : .black

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

        state.castlingRights = castlingRights

        states.append(state)
    }

    private init(board: BitBoard) {
        pieces = board.pieces
        states = board.states
    }

    public mutating func reset() {
        states = [GameState()]

        let pawns = 0b11111111
        pieces[Color.white][PieceType.pawn] = pawns << 8
        pieces[Color.black][PieceType.pawn] = pawns << (8 * 6)

        let rooks = 0b10000001
        pieces[Color.white][PieceType.rook] = rooks
        pieces[Color.black][PieceType.rook] = rooks << (8 * 7)

        let knights = 0b01000010
        pieces[Color.white][PieceType.knight] = knights
        pieces[Color.black][PieceType.knight] = knights << (8 * 7)

        let bishops = 0b00100100
        pieces[Color.white][PieceType.bishop] = bishops
        pieces[Color.black][PieceType.bishop] = bishops << (8 * 7)

        let queen = 0b00010000
        pieces[Color.white][PieceType.queen] = queen
        pieces[Color.black][PieceType.queen] = queen << (8 * 7)

        let king = 0b00001000
        pieces[Color.white][PieceType.king] = king
        pieces[Color.black][PieceType.king] = king << (8 * 7)
    }

//    public func makeMove(from: Int,
//                         to: Int,
//                         for piece: Int,
//                         of color: Int) -> BitBoard {
//        
//

    mutating func make(move: OldMove) {
        guard let moving = getPiece(at: move.source) else {
            return
        }

        set(square: move.source, to: nil)
        set(square: move.target, to: moving)

        var state = states.last ?? GameState()

        if move.isCastle {
            if move.target - move.source > 0 {
                set(square: moving.color == .white ? 7 : 63,
                    to: nil)
                set(square: move.target - 1,
                    to: Piece(color: moving.color,
                              type: .rook))
            } else {
                set(square: moving.color == .white ? 0 : 56,
                    to: nil)
                set(square: move.target + 1,
                    to: Piece(color: moving.color,
                              type: .rook))
            }
        }

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

        state.turnToMove = state.turnToMove.next

        states.append(state)
    }

    mutating func unmake(move: OldMove) {
        precondition(states.count > 1,
                     "Cannot undo a move from the starting position")

        guard let moving = getPiece(at: move.target) else {
            return
        }

        set(square: move.target, to: move.capturedPiece)
        set(square: move.source, to: moving)

        if move.isCastle {
            if move.target - move.source > 0 {
                set(square: moving.color == .white ? 7 : 63,
                    to: Piece(color: moving.color,
                              type: .rook))
                set(square: move.target - 1,
                    to: nil)
            } else {
                set(square: moving.color == .white ? 0 : 56,
                    to: Piece(color: moving.color,
                              type: .rook))
                set(square: move.target + 1,
                    to: nil)
            }
        }

        states.removeLast()
    }

    mutating func set(square: Int, to piece: Piece?) {
        for color in Color.allCases {
            for pieceType in PieceType.allCases {
                pieces[color][pieceType][square] = false
            }
        }

        guard let piece = piece else { return }

        pieces[piece.color][piece.type][square] = true
        pieces[Color.all][piece.type][square] = true
        pieces[piece.color][PieceType.all][square] = true
        pieces[Color.all][PieceType.all][square] = true
    }

    public func getPiece(at square: Int) -> Piece? {
        guard pieces[Color.all][PieceType.all][square] else { return nil }

        for color in Color.allCases {
            for pieceType in PieceType.allCases {
                guard pieces[color][pieceType][square] else { continue }

                return Piece(color: color,
                             type: pieceType)
            }
        }

        return nil
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
        default:
            moves = []
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
        let pawns = pieces[color][PieceType.pawn]

        var moves = [OldMove]()
        pawns.forEach { source in
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
        let knights = pieces[color][PieceType.knight]

        var moves = [OldMove]()
        knights.forEach { square in
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

    private func possibleKnightMoves2(for color: Color) -> [OldMove] {
        let knights = pieces[color][PieceType.knight]

        var moves = [OldMove]()
        for source in 0 ..< 64 {
            guard knights & (1 << source) == 1 else { continue }

            let targets = Moves.knightMoves[source]
            for target in 0 ..< 64 {
                guard targets & (1 << target) == 1 else { continue }

                let targetOccupant = getPiece(at: target)
                guard targetOccupant?.color != color else { continue }

                let move = OldMove(source: source,
                                target: target,
                                isCastle: false,
                                capturedPiece: targetOccupant,
                                priorState: states.last!)

                moves.append(move)
            }
        }

        return moves
    }

    private func possibleBishopMoves(for color: Color) -> [OldMove] {
        let bishops = pieces[color][PieceType.bishop]

        var moves = [OldMove]()
        bishops.forEach { square in
            moves.append(contentsOf: movesForBishop(at: square,
                                                    of: color))
        }

        return moves
    }

    private func movesForBishop(at square: Int, of color: Color) -> [OldMove] {
        var moves = [OldMove]()

        for direction in 0 ..< 4 {
            let blockedSquares = pieces[Color.all][PieceType.all] & Moves.bishopMoves[direction][square]

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
        let rooks = pieces[color][PieceType.rook]

        var moves = [OldMove]()
        rooks.forEach { square in
            moves.append(contentsOf: movesForRook(at: square,
                                                  of: color))
        }

        return moves
    }

    private func movesForRook(at square: Int, of color: Color) -> [OldMove] {
        var moves = [OldMove]()
        for direction in 0 ..< 4 {
            let blockedSquares = pieces[Color.all][PieceType.all] & Moves.rookMoves[direction][square]

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
        let queens = pieces[color][PieceType.queen]

        var moves = [OldMove]()
        queens.forEach { square in
            moves.append(contentsOf: movesForBishop(at: square,
                                                    of: color))
            moves.append(contentsOf: movesForRook(at: square,
                                                  of: color))
        }

        return moves
    }

    private func possibleKingMoves(for color: Color) -> [OldMove] {
        let kings = pieces[color][PieceType.king]

        var moves = [OldMove]()
        kings.forEach { square in
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
        for i in 0 ..< 64 {
            let index = 1 << (63 - i)
            var piece = ""
            if index & pieces[Color.white][PieceType.king] != 0 {
                piece = "♔"
            } else if index & pieces[Color.white][PieceType.queen] != 0 {
                piece = "♕"
            } else if index & pieces[Color.white][PieceType.rook] != 0 {
                piece = "♖"
            } else if index & pieces[Color.white][PieceType.bishop] != 0 {
                piece = "♗"
            } else if index & pieces[Color.white][PieceType.knight] != 0 {
                piece = "♘"
            } else if index & pieces[Color.white][PieceType.pawn] != 0 {
                piece = "♙"
            } else if index & pieces[Color.black][PieceType.king] != 0 {
                piece = "♚"
            } else if index & pieces[Color.black][PieceType.queen] != 0 {
                piece = "♛"
            } else if index & pieces[Color.black][PieceType.rook] != 0 {
                piece = "♜"
            } else if index & pieces[Color.black][PieceType.bishop] != 0 {
                piece = "♝"
            } else if index & pieces[Color.black][PieceType.knight] != 0 {
                piece = "♞"
            } else if index & pieces[Color.black][PieceType.pawn] != 0 {
                piece = "♟︎"
            } else {
                piece = " "
            }

            row = " \(piece) |" + row

            if (i + 1) % 8 == 0 {
                lines.append("\(8 - (i / 8)) |" + row)
                lines.append(divider)
                row = ""
            }
        }

        lines.append("    a   b   c   d   e   f   g   h")

        return lines.joined(separator: "\n")
    }
}
