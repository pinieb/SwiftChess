public enum Move {
    case quiet(from: SquareSet, to: SquareSet)
    case capture(from: SquareSet, to: SquareSet)
    case enPassant(from: SquareSet, to: SquareSet)
    case castle(_ side: Castle)
    case promotion(from: SquareSet, piece: PieceType)
    case pass
}

extension Move: CustomStringConvertible {
    public var description: String {
        var action = ""
        var source: SquareSet
        var target: SquareSet

        switch self {
        case let .castle(side):
            return side.notation
        case let .promotion(s, piece):
            return "\(s)=\(piece.notation)"
        case let .quiet(s, t):
            source = s
            target = t
            action = "-"
        case let .capture(s, t),
            let .enPassant(s, t):
            source = s
            target = t
            action = "x"
        case .pass:
            return "pass"
        }

        return "\(source)\(action)\(target)"
    }
}

public extension Move {
    func longAlgebraicNotation(color: Color) -> String {
        var source: SquareSet
        var target: SquareSet

        var promotion = ""

        switch self {
        case let .castle(side):
            if color == .white {
                source = .e1
                target = side == .kingside ? .g1 : .c1
            } else {
                source = .e8
                target = side == .kingside ? .g8 : .c8
            }

        case let .promotion(s, piece):
            source = s
            target = s.shifted(by: color == .white ? 8 : -8)
            promotion = "\(piece.notation.lowercased())"

        case let .quiet(s, t),
            let .capture(s, t),
            let .enPassant(s, t):
            source = s
            target = t

        case .pass:
            return "pass"
        }

        return "\(source)\(target)\(promotion)"
    }
}
