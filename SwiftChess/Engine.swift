import ChessKit
import Foundation

class Engine {
    var position = BitBoard()

    public var nextLine: () -> String? = {
        guard let line = readLine() else { return nil }

        // log here

        return line
    }

    public var sendMessage: (String) -> () = { line in
        // log here
        print(line)
    }

    public func run() {
        while let line = nextLine() {
            let components = line.split(separator: " ")
            guard !components.isEmpty else { break }

            let command = components[0]

            switch command {
            case "uci":
                sendMessage("id name SwiftChess")
                sendMessage("id author Pete Biencourt")
                sendMessage("uciok")

            case "isready":
                sendMessage("readyok")

            case "go":
                let moves = MoveGenerator.generateMoves(from: position)
                let move = moves[Int.random(in: 0 ..< moves.count)]
                sendMessage("bestmove \(move.longAlgebraicNotation(color: position.turnToMove))")

            default: continue
            }
        }

        exit(0)
    }
}
