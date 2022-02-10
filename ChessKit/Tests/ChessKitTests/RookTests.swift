import XCTest
@testable import ChessKit

final class RookTests: XCTestCase {
    func testMovesOnEmptyBoard() {
        for row in 0 ..< 8 {
            for column in 0 ..< 8 {
                let expectedTargets = [
                    [-7, 0],
                    [-6, 0],
                    [-5, 0],
                    [-4, 0],
                    [-3, 0],
                    [-2, 0],
                    [-1, 0],
                    [0, -7],
                    [0, -6],
                    [0, -5],
                    [0, -4],
                    [0, -3],
                    [0, -2],
                    [0, -1],
                    [0, 7],
                    [0, 6],
                    [0, 5],
                    [0, 4],
                    [0, 3],
                    [0, 2],
                    [0, 1],
                    [7, 0],
                    [6, 0],
                    [5, 0],
                    [4, 0],
                    [3, 0],
                    [2, 0],
                    [1, 0],
                ]
                    .map { [$0[0] + row, $0[1] + column] }
                    .filter {
                        let isValidRow = 0 <= $0[0] && $0[0] < 8
                        let isValidColumn = 0 <= $0[1] && $0[1] < 8

                        return isValidRow && isValidColumn
                    }
                    .map { $0[0] * 8 + $0[1] }
                    .sorted()

                let square = SquareIndex(rawValue: row * 8 + column)!
                var board = BitBoard(from: "8/8/8/8/8/8/8/8")
                board.set(square: square,
                          to: Piece(color: .black,
                                    type: .rook))
//
//                let actualTargets = board.getMoves(from: square)
//                    .map { $0.target }
//                    .sorted()
//
//                XCTAssertEqual(actualTargets,
//                               expectedTargets,
//                               "Rook moves do not match at (\(row), \(column))")
            }
        }
    }

    func testBlocked() {
        let board = BitBoard(from: "4P3/8/8/1P2R2P/8/8/4P3/8")
        let moves = board.getMoves(from: 36)
            .map { $0.target }
            .sorted()

        let expectedMoves = [20, 28, 34, 35, 37, 38, 44, 52]

        XCTAssertEqual(moves,
                       expectedMoves,
                       "Rook moves do not match")
    }

    func testCapture() {
        XCTFail()
    }
}
