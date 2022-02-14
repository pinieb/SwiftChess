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

