import XCTest
@testable import ChessKit

final class KnightTests: XCTestCase {
    func testMovesOnEmptyBoard() {
        for row in 0 ..< 8 {
            for column in 0 ..< 8 {
                let expectedTargets = [
                    [-2, -1],
                    [-2, 1],
                    [-1, -2],
                    [-1, 2],
                    [1, -2],
                    [1, 2],
                    [2, -1],
                    [2, 1]
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
                          to: Piece(color: .white,
                                    type: .knight))

                let moves = MoveGenerator.generateMoves(from: board)

                print(moves)

//                let actualTargets = board.getMoves(from: square)
//                    .map { $0.target }
//                    .sorted()

//                XCTAssertEqual(actualTargets,
//                               expectedTargets,
//                               "Knight moves do not match at (\(row), \(column))")
            }
        }
    }

    func testBlocked() {
        let board = BitBoard(from: "8/4p3/5p2/3N4/1P3P2/2P1P3/8/8")
        let moves = board.getMoves(from: 35)
            .map { $0.target }
            .sorted()

        let expectedMoves = [41, 45, 50, 52]

        XCTAssertEqual(moves,
                       expectedMoves,
                       "Knight moves do not match")
    }

    func testCapture() {
        XCTFail()
    }
}
