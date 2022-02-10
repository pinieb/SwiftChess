import XCTest
@testable import ChessKit

final class KingTests: XCTestCase {
    func testMovesOnEmptyBoard() {
        for row in 0 ..< 8 {
            for column in 0 ..< 8 {
                let expectedTargets = [
                    [-1, -1],
                    [-1, 0],
                    [-1, 1],
                    [0, -1],
                    [0, 1],
                    [1, -1],
                    [1, 0],
                    [1, 1]
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
                                    type: .king))
//
//                let actualTargets = board.getMoves(from: square)
//                    .map { $0.target }
//                    .sorted()
//
//                XCTAssertEqual(actualTargets,
//                               expectedTargets,
//                               "King moves do not match at (\(row), \(column))")
            }
        }
    }

    func testBlocked() {
        let board = BitBoard(from: "8/8/3PPP2/3PKP2/3PPP2/8/8/8")
        let moves = board.getMoves(from: 36)
            .map { $0.target }
            .sorted()

        XCTAssertTrue(moves.isEmpty,
                     "King should not be able to move")
    }

    func testCapture() {
        XCTFail()
    }

    func testCastle() {
        XCTFail()
    }
}
