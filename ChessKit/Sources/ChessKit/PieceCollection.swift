public struct PieceCollection {
    private var pieces: [[SquareSet]]

    public private(set) var attackedSquares: [SquareSet]
    private(set) var kingDangerSquares: [SquareSet]

    public var all: SquareSet {
        self[.white].union(self[.black])
    }

    public init() {
        pieces = [[SquareSet]](repeating: [SquareSet](repeating: .none,
                                                      count: PieceType.allCases.count),
                               count: Color.allCases.count)
        attackedSquares = [SquareSet](repeating: 0,
                                      count: Color.allCases.count)
        kingDangerSquares = [SquareSet](repeating: 0,
                                        count: Color.allCases.count)
    }

    public init(pieces: [[SquareSet]]) {
        precondition(pieces.count == Color.allCases.count, "Pieces is the wrong size")
        precondition(pieces[0].count == PieceType.allCases.count, "Pieces is the wrong size")

        self.init()
        self.pieces = pieces

        updateAttackedSquares()
    }

    public mutating func clear(squares: SquareSet) {
        for color in 0 ..< pieces.count {
            for piece in 0 ..< pieces[color].count {
                pieces[color][piece].remove(squares)
            }
        }
    }

    private mutating func updateAttackedSquares() {
        for color in Color.allCases {
            attackedSquares[color] = 0

            attackedSquares[color].formUnion(pawnAttackSet(color: color))
            attackedSquares[color].formUnion(knightAttackSet(color: color))
            attackedSquares[color].formUnion(kingAttackSet(color: color))

            kingDangerSquares[color.opponent] = attackedSquares[color]

            attackedSquares[color].formUnion(diagonalAttackSet(color: color,
                                                               piece: .bishop))
            attackedSquares[color].formUnion(orthogonalAttackSet(color: color,
                                                                 piece: .rook))

            kingDangerSquares[color.opponent]
                .formUnion(diagonalAttackSet(color: color,
                                             piece: .bishop,
                                             ignoredBlockers: self[color.opponent, .king]))
            kingDangerSquares[color.opponent]
                .formUnion(orthogonalAttackSet(color: color,
                                               piece: .rook,
                                               ignoredBlockers: self[color.opponent, .king]))

            attackedSquares[color].formUnion(diagonalAttackSet(color: color,
                                                               piece: .queen))
            attackedSquares[color].formUnion(orthogonalAttackSet(color: color,
                                                                 piece: .queen))

            kingDangerSquares[color.opponent]
                .formUnion(diagonalAttackSet(color: color,
                                             piece: .queen,
                                             ignoredBlockers: self[color.opponent, .king]))
            kingDangerSquares[color.opponent]
                .formUnion(orthogonalAttackSet(color: color,
                                               piece: .queen,
                                               ignoredBlockers: self[color.opponent, .king]))
        }
    }

    private func pawnAttackSet(color: Color,
                               squareMask: SquareSet = .all) -> SquareSet {
        let leftShift = color == .white ? 7 : -9
        let rightShift = color == .white ? 9 : -7

        var attackSet = SquareSet.none

        // left
        var pawns = self[color, .pawn].intersection(squareMask)
        pawns.remove(.aFile)

        attackSet.formUnion(pawns.shifted(by: leftShift))

        // right
        pawns = self[color, .pawn].intersection(squareMask)
        pawns.remove(.hFile)

        attackSet.formUnion(pawns.shifted(by: rightShift))

        return attackSet
    }

    private func knightAttackSet(color: Color,
                                 squareMask: SquareSet = .all) -> SquareSet {
        var attackSet = SquareSet.none

        self[color, .knight]
            .intersection(squareMask)
            .rawValue
            .forEach {
                attackSet.formUnion(MoveSets.knight[$0])
            }

        return attackSet
    }

    private func kingAttackSet(color: Color) -> SquareSet {
        var attackSet = SquareSet.none

        self[color, .king]
            .rawValue
            .forEach {
                attackSet.formUnion(MoveSets.king[$0])
            }

        return attackSet
    }

    private func diagonalAttackSet(color: Color,
                                   piece: PieceType,
                                   squareMask: SquareSet = .all,
                                   ignoredBlockers: SquareSet = .none) -> SquareSet {
        guard piece == .bishop || piece == .queen else { return .none }

        var attackSet = SquareSet.none

        self[color, piece]
            .intersection(squareMask)
            .rawValue
            .forEach {
                for direction in 0 ..< 4 {
                    var blockedSquares = self.all
                        .intersection(MoveSets.bishop[direction][$0])
                    blockedSquares.remove(ignoredBlockers)


                    var firstHit: Int?
                    if direction < 2 {
                        firstHit = blockedSquares.rawValue.last
                    } else {
                        firstHit = blockedSquares.rawValue.first
                    }

                    var availableSquares = MoveSets.bishop[direction][$0]
                    if let firstHit = firstHit {
                        availableSquares.remove(MoveSets.bishop[direction][firstHit])
                    }

                    attackSet.formUnion(availableSquares)
                }
            }

        return attackSet
    }

    private func orthogonalAttackSet(color: Color,
                                     piece: PieceType,
                                     squareMask: SquareSet = .all,
                                     ignoredBlockers: SquareSet = .none) -> SquareSet {
        guard piece == .rook || piece == .queen else { return .none }

        var attackSet = SquareSet.none

        self[color, piece]
            .intersection(squareMask)
            .rawValue
            .forEach {
                for direction in 0 ..< 4 {
                    var blockedSquares = self.all
                        .intersection(MoveSets.rook[direction][$0])
                    blockedSquares.remove(ignoredBlockers)

                    var firstHit: Int?
                    if direction < 2 {
                        firstHit = blockedSquares.rawValue.last
                    } else {
                        firstHit = blockedSquares.rawValue.first
                    }

                    var availableSquares = MoveSets.rook[direction][$0]
                    if let firstHit = firstHit {
                        availableSquares.remove(MoveSets.rook[direction][firstHit])
                    }

                    attackSet.formUnion(availableSquares)
                }
            }

        return attackSet
    }

    public func isInCheck(color: Color) -> Bool {
        kingDangerSquares[color].intersection(self[color, .king]) != .none
    }

    public subscript(_ color: Color) -> SquareSet {
        get {
            pieces[color].reduce(into: SquareSet()) {
                $0.formUnion($1)
            }
        }
    }

    public subscript(_ piece: PieceType) -> SquareSet {
        get {
            pieces[Color.white][piece].union(pieces[Color.black][piece])
        }
    }

    public subscript(_ color: Color, _ piece: PieceType) -> SquareSet {
        get {
            pieces[color][piece]
        }
        set {
            pieces[color][piece] = newValue
            updateAttackedSquares()
        }
    }

    public subscript(_ piece: Piece) -> SquareSet {
        get {
            pieces[piece.color][piece.type]
        }
        set {
            pieces[piece.color][piece.type] = newValue
            updateAttackedSquares()
        }
    }

    public subscript(_ index: SquareIndex) -> Piece? {
        get {
            let square = SquareSet(index: index)

            for color in Color.allCases {
                for piece in PieceType.allCases {
                    guard !pieces[color][piece].contains(square) else {
                        return Piece(color: color, type: piece)
                    }
                }
            }

            return nil
        }
    }
}

public extension PieceCollection {
    static var startingPosition: PieceCollection {
        var position = PieceCollection()

        position.pieces[Color.white][PieceType.pawn] = .rank2
        position.pieces[Color.white][PieceType.rook] = [.a1, .h1]
        position.pieces[Color.white][PieceType.knight] = [.b1, .g1]
        position.pieces[Color.white][PieceType.bishop] = [.c1, .f1]
        position.pieces[Color.white][PieceType.queen] = [.d1]
        position.pieces[Color.white][PieceType.king] = [.e1]

        position.pieces[Color.black][PieceType.pawn] = .rank7
        position.pieces[Color.black][PieceType.rook] = [.a8, .h8]
        position.pieces[Color.black][PieceType.knight] = [.b8, .g8]
        position.pieces[Color.black][PieceType.bishop] = [.c8, .f8]
        position.pieces[Color.black][PieceType.queen] = [.d8]
        position.pieces[Color.black][PieceType.king] = [.e8]

        position.updateAttackedSquares()

        return position
    }
}
