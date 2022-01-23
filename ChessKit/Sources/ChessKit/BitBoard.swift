public struct BitBoard {
    // [color][piece][position]
    private let moves: [[[Int]]] = [
        // white
        [
            // pawns
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 16777216, 33554432, 67108864, 134217728, 268435456, 536870912, 1073741824, 2147483648, 4294967296, 8589934592, 17179869184, 34359738368, 68719476736, 137438953472, 274877906944, 549755813888, 1099511627776, 2199023255552, 4398046511104, 8796093022208, 17592186044416, 35184372088832, 70368744177664, 140737488355328, 281474976710656, 562949953421312, 1125899906842624, 2251799813685248, 4503599627370496, 9007199254740992, 18014398509481984, 36028797018963968, 72057594037927936, 144115188075855872, 288230376151711744, 576460752303423488, 1152921504606846976, 2305843009213693952, 4611686018427387904, -9223372036854775808, 0, 0, 0, 0, 0, 0, 0, 0],
            // knights
            [Int](repeating: 0, count: 64),
            // bishops
            [Int](repeating: 0, count: 64),
            // rooks
            [Int](repeating: 0, count: 64),
            // queens
            [Int](repeating: 0, count: 64),
            // kings,
            [Int](repeating: 0, count: 64),
        ],
        // black
        [
            // pawns
            [0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384, 32768, 65536, 131072, 262144, 524288, 1048576, 2097152, 4194304, 8388608, 16777216, 33554432, 67108864, 134217728, 268435456, 536870912, 1073741824, 2147483648, 4294967296, 8589934592, 17179869184, 34359738368, 68719476736, 137438953472, 274877906944, 549755813888, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            // knights
            [Int](repeating: 0, count: 64),
            // bishops
            [Int](repeating: 0, count: 64),
            // rooks
            [Int](repeating: 0, count: 64),
            // queens
            [Int](repeating: 0, count: 64),
            // kings,
            [Int](repeating: 0, count: 64),
        ],
    ]

    private var pieces: [[Int]]

    public init() {
        pieces = [[Int]](repeating: [Int](repeating: 0,
                                          count: PieceType.all.rawValue + 1),
                         count: Color.all.rawValue + 1)
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
//    }

    public func possibleMoves(for color: Color) -> [Move] {
        // for each piece of color
        // get the bitmap
        // for index of each 1 in bitmap, get moves bitmap
        // for index of each 1 in moves, add a new move to the list

        return []
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
