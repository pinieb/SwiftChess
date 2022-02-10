public struct PieceCollection {
    private var pieces: [[SquareSet]]

    private var attackedSquares: [SquareSet]
    private var kingDangerSquares: [SquareSet]

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

    public mutating func clear(squares: SquareSet) {
        for color in 0 ..< pieces.count {
            for piece in 0 ..< pieces[color].count {
                pieces[color][piece].remove(squares)
            }
        }
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
        }
    }

    public subscript(_ piece: Piece) -> SquareSet {
        get {
            pieces[piece.color][piece.type]
        }
        set {
            pieces[piece.color][piece.type] = newValue
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
