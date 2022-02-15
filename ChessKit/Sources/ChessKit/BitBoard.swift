public struct BitBoard: Board {
    var states = [GameState]()
    var pieces: PieceCollection

    public var turnToMove: Color { states.last!.turnToMove }
    public var enPassant: SquareSet { states.last!.enPassant }

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

        var nextState = states.last!.next
        nextState.fiftyMoveCounter = 0

        return nextState
    }

    private mutating func playEnPassant(source: SquareSet, target: SquareSet) -> GameState {
        let pawnSquare = SquareIndex(rawValue: source.rawValue.first!)!
        let targetSquare = SquareIndex(rawValue: target.rawValue.first!)!

        // move our pawn
        set(square: pawnSquare, to: nil)
        set(square: targetSquare, to: Piece(color: turnToMove,
                                            type: .pawn))

        // remove their pawn
        let otherPawn = target.shifted(by: turnToMove == .white ? -8 : 8)
        let otherPawnSquare = SquareIndex(rawValue: otherPawn.rawValue.first!)!
        set(square: otherPawnSquare, to: nil)

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

        let capturedPiece = getPiece(at: targetSquare.rawValue)
        if capturedPiece != nil {
            nextState.capturedPiece = capturedPiece
        }

        if piece.type == .pawn || capturedPiece != nil {
            nextState.fiftyMoveCounter = 0
        }

        let doublePushMask: SquareSet = turnToMove == .white ? [.rank2, .rank4] : [.rank7, .rank5]
        if piece.type == .pawn, doublePushMask.contains(source.union(target)) {
            nextState.enPassant = target.shifted(by: turnToMove == .white ? -8 : 8)
        }

        set(square: sourceSquare, to: nil)
        set(square: targetSquare, to: piece)

        return nextState
    }

    mutating func unmake(move: Move) {
        guard states.count > 1 else { return }

        switch move {
        case let .castle(side):
            undoCastle(side: side)
        case let .promotion(source, piece):
            undoPromotion(source: source,
                          piece: piece)
        case let .enPassant(source, target):
            undoEnPassant(source: source,
                          target: target)
        case let .quiet(source, target),
            let .capture(source, target):
            undoMove(source: source,
                     target: target)
        }
    }

    private mutating func undoCastle(side: Castle) {
        states.removeLast()

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

        set(square: kingStart, to: Piece(color: turnToMove,
                                         type: .king))
        set(square: rookStart, to: Piece(color: turnToMove,
                                         type: .rook))
        set(square: kingEnd, to: nil)
        set(square: rookEnd, to: nil)
    }

    private mutating func undoPromotion(source: SquareSet, piece: PieceType) {
        states.removeLast()

        let pawnSquare = SquareIndex(rawValue: source.rawValue.first!)!

        let direction = turnToMove == .white ? 8 : -8
        let promotionSquare = SquareIndex(rawValue: pawnSquare.rawValue + direction)!

        set(square: pawnSquare, to: Piece(color: turnToMove,
                                          type: .pawn))
        set(square: promotionSquare, to: nil)
    }

    private mutating func undoEnPassant(source: SquareSet, target: SquareSet) {
        states.removeLast()

        let pawnSquare = SquareIndex(rawValue: source.rawValue.first!)!
        let targetSquare = SquareIndex(rawValue: target.rawValue.first!)!

        // put our pawn back
        set(square: pawnSquare, to: Piece(color: turnToMove,
                                          type: .pawn))
        set(square: targetSquare, to: nil)

        // put enemy pawn back on the board
        let otherPawn = target.shifted(by: turnToMove == .white ? 8 : -8)
        let otherPawnSquare = SquareIndex(rawValue: otherPawn.rawValue.first!)!
        set(square: otherPawnSquare, to: Piece(color: turnToMove.opponent,
                                               type: .pawn))
    }

    private mutating func undoMove(source: SquareSet, target: SquareSet) {
        guard let piece = getPiece(at: target) else { return }

        let sourceSquare = SquareIndex(rawValue: source.rawValue.first!)!
        let targetSquare = SquareIndex(rawValue: target.rawValue.first!)!

        set(square: sourceSquare, to: piece)
        set(square: targetSquare, to: states.last?.capturedPiece)

        states.removeLast()
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

    public func printAttackedSquares() {
        print(pieces.attackedSquares)
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
