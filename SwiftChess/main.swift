import ChessKit
import Darwin

setbuf(__stdoutp, nil)

var engine = Engine()
engine.run()

//var lines = [String]()
//

//let mode = readLine()
//print("id name SwiftChess")
//print("id author Pete Biencourt")

// can send options here

//print("uciok")

//while let line = readLine() {
//    guard line != "isReady" else { break }
//
//    // can receive options here
//}

// setup based on options
//print("readyok")

//while let line = readLine() {
//    guard line != "ucinewgame" else { break }
//}

//print("bestmove e2e4")
//
//
//while let line = readLine() {
//    guard line != "isReady" else { break }
//}
////
////sleep(30)
//
//print("readyok")
//
//let position = readLine()
//print("info string hi \(position)")
//print("bestmove e2e4")
//
//exit(0)
//
////var board = BitBoard()
////var moveNumber = 0
////
////while true {
////    print("========== \(moveNumber / 2 + 1) ==========")
////    print(board)
////
////    let moves = MoveGenerator.generateMoves(from: board)
////    moves.enumerated().forEach { index, move in
////        print("\(index): \(move.longAlgebraicNotation(color: board.turnToMove))")
////    }
////
////    print("Choose a move: ")
////
////    guard let input = readLine(),
////          let move = Int(input),
////          0 <= move,
////          move < moves.count else {
////        break
////    }
////
////    board.make(move: moves[move])
////    moveNumber += 1
////}
//func nextLine() -> String? {
//    guard let line = readLine() else { return nil }
//
//    lines.append(line)
//    print("info string \(line)")
//
//    return line
//}
