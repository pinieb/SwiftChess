public struct BitBoard: Board {
    var pieces: [[Int]]

    init(from fen: String = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR") {
        pieces = [[Int]](repeating: [Int](repeating: 0,
                                          count: PieceType.all.rawValue + 1),
                         count: Color.all.rawValue + 1)

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
    }

    private init(board: BitBoard) {
        self.pieces = board.pieces
    }

    public mutating func reset() {
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

    public func getMoves(from square: Int) -> [Move] {
        guard let piece = getPiece(at: square) else {
            return []
        }

        var moves: [Move]
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
            moves = []
        case .king:
            moves = []
        default:
            moves = []
        }

        return moves
    }

    public func possibleMoves(for color: Color) -> [Move] {
        var moves = [Move]()
        
        moves.append(contentsOf: possiblePawnMoves(for: color))
        moves.append(contentsOf: possibleKnightMoves(for: color))
        moves.append(contentsOf: possibleKingMoves(for: color))
        moves.append(contentsOf: possibleBishopMoves(for: color))
        moves.append(contentsOf: possibleRookMoves(for: color))

        // TODO: Queen moves

        return moves
    }

    private func possiblePawnMoves(for color: Color) -> [Move] {
        let pawns = pieces[color][PieceType.pawn]

        var moves = [Move]()
        pawns.forEach { source in
            moves.append(contentsOf: movesForPawn(at: source,
                                                  of: color))
        }

        return moves
    }

    private func movesForPawn(at square: Int, of color: Color) -> [Move] {
        var moves = [Move]()

        Moves.pawnMoves[color][square].forEach { target in
            guard getPiece(at: target) == nil else { return }

            moves.append(Move(source: square,
                              target: target,
                              capturedPiece: nil))
        }

        // TODO: check for captures and en passant

        return moves
    }

    private func possibleKnightMoves(for color: Color) -> [Move] {
        let knights = pieces[color][PieceType.knight]

        var moves = [Move]()
        knights.forEach { square in
            moves.append(contentsOf: movesForKnight(at: square,
                                                    of: color))
        }

        return moves
    }

    private func movesForKnight(at square: Int, of color: Color) -> [Move] {
        var moves = [Move]()

        Moves.knightMoves[square].forEach { target in
            let targetOccupant = getPiece(at: target)
            guard targetOccupant?.color != color else { return }

            moves.append(Move(source: square,
                              target: target,
                              capturedPiece: targetOccupant))
        }

        return moves
    }

    private func possibleKnightMoves2(for color: Color) -> [Move] {
        let knights = pieces[color][PieceType.knight]

        var moves = [Move]()
        for source in 0 ..< 64 {
            guard knights & (1 << source) == 1 else { continue }

            let targets = Moves.knightMoves[source]
            for target in 0 ..< 64 {
                guard targets & (1 << target) == 1 else { continue }

                let targetOccupant = getPiece(at: target)
                guard targetOccupant?.color != color else { continue }

                moves.append(Move(source: source,
                                  target: target,
                                  capturedPiece: targetOccupant))
            }
        }

        return moves
    }

    private func possibleBishopMoves(for color: Color) -> [Move] {
        let bishops = pieces[color][PieceType.bishop]

        var moves = [Move]()
        bishops.forEach { square in
            moves.append(contentsOf: movesForBishop(at: square,
                                                    of: color))
        }

        return moves
    }

    private func movesForBishop(at square: Int, of color: Color) -> [Move] {
        var moves = [Move]()

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

                moves.append(Move(source: square,
                                  target: target,
                                  capturedPiece: targetOccupant))
            }
        }

        return moves
    }

    private func possibleRookMoves(for color: Color) -> [Move] {
        let rooks = pieces[color][PieceType.rook]

        var moves = [Move]()
        rooks.forEach { square in
            moves.append(contentsOf: movesForRook(at: square,
                                                  of: color))
        }

        return moves
    }

    private func movesForRook(at square: Int, of color: Color) -> [Move] {
        var moves = [Move]()
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

                moves.append(Move(source: square,
                                  target: target,
                                  capturedPiece: targetOccupant))
            }
        }

        return moves
    }

    private func possibleKingMoves(for color: Color) -> [Move] {
        let kings = pieces[color][PieceType.king]

        var moves = [Move]()
        kings.forEach { source in
            Moves.kingMoves[source].forEach { target in
                let targetOccupant = getPiece(at: target)
                guard targetOccupant?.color != color else { return }

                // TODO: Make sure move doesn't end in check

                moves.append(Move(source: source,
                                  target: target,
                                  capturedPiece: targetOccupant))
            }

            // TODO: Check castling
        }

        return moves
    }

    public func printBoard() {
        var row = ""
        for i in 0 ..< 64 {
            let index = 1 << (63 - i)
            if index & pieces[Color.white][PieceType.king] != 0 {
                row += "♔"
            } else if index & pieces[Color.white][PieceType.queen] != 0 {
                row += "♕"
            } else if index & pieces[Color.white][PieceType.rook] != 0 {
                row += "♖"
            } else if index & pieces[Color.white][PieceType.bishop] != 0 {
                row += "♗"
            } else if index & pieces[Color.white][PieceType.knight] != 0 {
                row += "♘"
            } else if index & pieces[Color.white][PieceType.pawn] != 0 {
                row += "♙"
            } else if index & pieces[Color.black][PieceType.king] != 0 {
                row += "♚"
            } else if index & pieces[Color.black][PieceType.queen] != 0 {
                row += "♛"
            } else if index & pieces[Color.black][PieceType.rook] != 0 {
                row += "♜"
            } else if index & pieces[Color.black][PieceType.bishop] != 0 {
                row += "♝"
            } else if index & pieces[Color.black][PieceType.knight] != 0 {
                row += "♞"
            } else if index & pieces[Color.black][PieceType.pawn] != 0 {
                row += "♟︎"
            } else {
                row += " "
            }

            if (i + 1) % 8 == 0 {
                print(row)
                row = ""
            }
        }
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
