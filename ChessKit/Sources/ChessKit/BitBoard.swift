public struct BitBoard {
    private var pieces: [[Int]]

    public init() {
        pieces = [[Int]](repeating: [Int](repeating: 0,
                                          count: PieceType.all.rawValue + 1),
                         count: Color.all.rawValue + 1)
    }

    private init(board: BitBoard) {
        self.pieces = board.pieces
    }

    init(from fen: String) {
        pieces = [[Int]](repeating: [Int](repeating: 0,
                                          count: PieceType.all.rawValue + 1),
                         count: Color.all.rawValue + 1)

        let components = fen.components(separatedBy: " ")
        let squares = components[0]

        var shift = 1
        for char in squares {
            guard char != "/" else { continue }

            for color in Color.allCases {
                for piece in PieceType.allCases {
                    pieces[color][piece] <<= shift
                }
            }

            if char.isNumber {
                shift = Int(String(char))!
            } else {
                shift = 1
            }

            switch char {
            case "P":
                pieces[Color.white][PieceType.pawn][0] = true
                pieces[Color.white][PieceType.all][0] = true
                pieces[Color.all][PieceType.pawn][0] = true
            case "p":
                pieces[Color.black][PieceType.pawn][0] = true
                pieces[Color.black][PieceType.all][0] = true
                pieces[Color.all][PieceType.pawn][0] = true
            case "N":
                pieces[Color.white][PieceType.knight][0] = true
                pieces[Color.white][PieceType.all][0] = true
                pieces[Color.all][PieceType.knight][0] = true
            case "n":
                pieces[Color.black][PieceType.knight][0] = true
                pieces[Color.black][PieceType.all][0] = true
                pieces[Color.all][PieceType.knight][0] = true
            case "B":
                pieces[Color.white][PieceType.bishop][0] = true
                pieces[Color.white][PieceType.all][0] = true
                pieces[Color.all][PieceType.bishop][0] = true
            case "b":
                pieces[Color.black][PieceType.bishop][0] = true
                pieces[Color.black][PieceType.all][0] = true
                pieces[Color.all][PieceType.knight][0] = true
            case "R":
                pieces[Color.white][PieceType.rook][0] = true
                pieces[Color.white][PieceType.all][0] = true
                pieces[Color.all][PieceType.rook][0] = true
            case "r":
                pieces[Color.black][PieceType.rook][0] = true
                pieces[Color.black][PieceType.all][0] = true
                pieces[Color.all][PieceType.rook][0] = true
            case "Q":
                pieces[Color.white][PieceType.queen][0] = true
                pieces[Color.white][PieceType.all][0] = true
                pieces[Color.all][PieceType.queen][0] = true
            case "q":
                pieces[Color.black][PieceType.queen][0] = true
                pieces[Color.black][PieceType.all][0] = true
                pieces[Color.all][PieceType.queen][0] = true
            case "K":
                pieces[Color.white][PieceType.king][0] = true
                pieces[Color.white][PieceType.all][0] = true
                pieces[Color.all][PieceType.king][0] = true
            case "k":
                pieces[Color.black][PieceType.king][0] = true
                pieces[Color.black][PieceType.all][0] = true
                pieces[Color.all][PieceType.king][0] = true
            default: continue
            }
        }

        if shift > 1 {
            for color in Color.allCases {
                for piece in PieceType.allCases {
                    pieces[color][piece] <<= shift - 1
                }
            }
        }
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
//    }

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
            Moves.pawnMoves[color][source].forEach { target in
                guard getOccupant(of: target) == nil else { return }

                moves.append(Move(source: source,
                                  target: target,
                                  capturedPiece: nil))
            }

            // TODO: check for captures and en passant
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

                let targetOccupant = getOccupant(of: target)
                guard targetOccupant?.color != color else { continue }

                moves.append(Move(source: source,
                                  target: target,
                                  capturedPiece: targetOccupant))
            }
        }

        return moves
    }

    private func possibleKnightMoves(for color: Color) -> [Move] {
        let knights = pieces[color][PieceType.knight]

        var moves = [Move]()
        knights.forEach { source in
            Moves.knightMoves[source].forEach { target in
                let targetOccupant = getOccupant(of: target)
                guard targetOccupant?.color != color else { return }

                moves.append(Move(source: source,
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
                let targetOccupant = getOccupant(of: target)
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

    private func possibleBishopMoves(for color: Color) -> [Move] {
        let bishops = pieces[color][PieceType.bishop]

        var moves = [Move]()
        bishops.forEach { source in
            for direction in 0 ..< 4 {
                let blockedSquares = pieces[Color.all][PieceType.all] & Moves.bishopMoves[direction][source]

                var firstHit: Int?
                if direction < 2 {
                    firstHit = blockedSquares.first
                } else {
                    firstHit = blockedSquares.last
                }

                var availableSquares = Moves.bishopMoves[direction][source]
                if let firstHit = firstHit {
                    availableSquares ^= Moves.bishopMoves[direction][firstHit]
                }

                availableSquares.forEach { target in
                    let targetOccupant = getOccupant(of: target)
                    guard targetOccupant?.color != color else { return }

                    moves.append(Move(source: source,
                                      target: target,
                                      capturedPiece: targetOccupant))
                }
            }
        }

        return moves
    }

    private func possibleRookMoves(for color: Color) -> [Move] {
        let rooks = pieces[color][PieceType.rook]

        var moves = [Move]()
        rooks.forEach { source in
            for direction in 0 ..< 4 {
                let blockedSquares = pieces[Color.all][PieceType.all] & Moves.rookMoves[direction][source]

                var firstHit: Int?
                if direction < 2 {
                    firstHit = blockedSquares.first
                } else {
                    firstHit = blockedSquares.last
                }

                var availableSquares = Moves.rookMoves[direction][source]
                if let firstHit = firstHit {
                    availableSquares ^= Moves.rookMoves[direction][firstHit]
                }

                availableSquares.forEach { target in
                    let targetOccupant = getOccupant(of: target)
                    guard targetOccupant?.color != color else { return }

                    moves.append(Move(source: source,
                                      target: target,
                                      capturedPiece: targetOccupant))
                }
            }
        }

        return moves
    }

    private func getOccupant(of square: Int) -> Piece? {
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
}
