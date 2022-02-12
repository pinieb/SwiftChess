//
//  main.swift
//  SwiftChess
//
//  Created by Pete Biencourt on 1/10/22.
//

import ChessKit
import Darwin

var board = BitBoard()
var moveNumber = 0
board.make(move: .quiet(from: .b2, to: .b4))
board.make(move: .quiet(from: .e7, to: .e5))
board.make(move: .quiet(from: .c1, to: .a3))
board.make(move: .quiet(from: .d7, to: .d5))
board.make(move: .quiet(from: .b4, to: .b5))
board.make(move: .capture(from: .f8, to: .a3))
board.make(move: .capture(from: .b1, to: .a3))
board.make(move: .quiet(from: .g8, to: .f6))
board.make(move: .quiet(from: .d1, to: .b1))
board.make(move: .quiet(from: .a7, to: .a6))
board.make(move: .quiet(from: .b1, to: .b2))
board.make(move: .quiet(from: .h7, to: .h6))

while true {
    print("========== \(moveNumber / 2 + 1) ==========")
    print(board)
    
    let moves = MoveGenerator.generateMoves(from: board)
    moves.enumerated().forEach { index, move in
        print("\(index): \(move)")
    }

    print("Choose a move: ")

    guard let input = readLine(),
          let move = Int(input),
          0 <= move,
          move < moves.count else {
        break
    }

    board.make(move: moves[move])
    moveNumber += 1
}

