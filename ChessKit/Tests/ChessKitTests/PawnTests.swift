import XCTest
@testable import ChessKit

final class PawnTests: XCTestCase {
    func testFirstMoves() {
        let board = BitBoard()

        for square in 8 ... 15 {
            let moves = board.getMoves(from: square)
            XCTAssertEqual(moves.count, 2)
            XCTAssertEqual(moves[0].target, square + 8)
            XCTAssertEqual(moves[1].target, square + 16)
        }

        for square in 48 ... 55 {
            let moves = board.getMoves(from: square)
            XCTAssertEqual(moves.count, 2)
            XCTAssertEqual(moves[0].target, square - 16)
            XCTAssertEqual(moves[1].target, square - 8)
        }
    }

    func testRegularMoves() {
        let board = BitBoard(from: "8/8/pppppppp/8/8/PPPPPPPP/8/8")

        for square in 16 ... 23 {
            let moves = board.getMoves(from: square)
            XCTAssertEqual(moves.count, 1)
            XCTAssertEqual(moves[0].target, square + 8)
        }

        for square in 40 ... 47 {
            let moves = board.getMoves(from: square)
            XCTAssertEqual(moves.count, 1)
            XCTAssertEqual(moves[0].target, square - 8)
        }
    }

    func testBlockedPawnsCantMove() {
        let board = BitBoard(from: "8/8/8/p1p1p1p1/P1P1P1P1/8/8/8")

        for square in 24 ... 31 {
            guard square.isMultiple(of: 2) else {
                XCTAssertNil(board.getPiece(at: square))
                return
            }

            XCTAssertNotNil(board.getPiece(at: square))

            let moves = board.getMoves(from: square)
            XCTAssertEqual(moves.count, 0)
        }

        for square in 32 ... 39 {
            guard square.isMultiple(of: 2) else {
                XCTAssertNil(board.getPiece(at: square))
                return
            }

            XCTAssertNotNil(board.getPiece(at: square))

            let moves = board.getMoves(from: square)
            XCTAssertEqual(moves.count, 0)
        }
    }

    func testNormalCapture() {
        XCTFail()
    }

    func testEnPassant() {
        XCTFail()
    }

    func testPromotion() {
        XCTFail()
    }
}
