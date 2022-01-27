import XCTest
@testable import ChessKit

final class ChessKitTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(ChessKit().text, "Hello, World!")

        var board = BitBoard(from: "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKB2")
        board.printBoard()
        board.reset()
        board.printBoard()
    }
}
