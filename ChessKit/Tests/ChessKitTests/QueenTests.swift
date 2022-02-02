import XCTest
@testable import ChessKit

final class QueenTests: XCTestRun {
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
                    [-7, -7],
                    [-6, -6],
                    [-5, -5],
                    [-4, -4],
                    [-3, -3],
                    [-2, -2],
                    [-1, -1],
                    [-7, 7],
                    [-6, 6],
                    [-5, 5],
                    [-4, 4],
                    [-3, 3],
                    [-2, 2],
                    [-1, 1],
                    [7, -7],
                    [6, -6],
                    [5, -5],
                    [4, -4],
                    [3, -3],
                    [2, -2],
                    [1, -1],
                    [7, 7],
                    [6, 6],
                    [5, 5],
                    [4, 4],
                    [3, 3],
                    [2, 2],
                    [1, 1],
                ]
                    .map { [$0[0] + row, $0[1] + column] }
                    .filter {
                        let isValidRow = 0 <= $0[0] && $0[0] < 8
                        let isValidColumn = 0 <= $0[1] && $0[1] < 8

                        return isValidRow && isValidColumn
                    }
                    .map { $0[0] * 8 + $0[1] }
                    .sorted()

                let square = row * 8 + column
                var board = BitBoard(from: "8/8/8/8/8/8/8/8")
                board.set(square: square, to: Piece(color: .white,
                                                    type: .queen))

                let actualTargets = board.getMoves(from: square)
                    .map { $0.target }
                    .sorted()

                XCTAssertEqual(actualTargets.map { [$0 / 8, $0 % 8] },
                               expectedTargets.map { [$0 / 8, $0 % 8] },
                               "Queen moves do not match at (\(row), \(column))")
            }
        }
    }

    func testBlocked() {
        let board = BitBoard(from: "4P3/2P3P1/8/1P2Q2P/8/2P3P1/4P3/8")
        let moves = board.getMoves(from: 36)
            .map { $0.target }
            .sorted()

        let expectedMoves = [20, 27, 28, 29, 34, 35, 37, 38, 43, 44, 45, 52]

        XCTAssertEqual(moves.map { [$0 / 8, $0 % 8] },
                       expectedMoves.map { [$0 / 8, $0 % 8] },
                       "Queen moves do not match")
    }

    func testCapture() {
        XCTFail()
    }
}
