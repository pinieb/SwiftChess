import ChessKit
import Foundation

class Engine {
    private var position = BitBoard()

    private let moveSelector: MoveSelector

    init(moveSelector: MoveSelector) {
        self.moveSelector = moveSelector
    }

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
            case "uci": identifyEngine()
            case "debug": continue
            case "isready": sendMessage("readyok")
            case "setoption": continue
            case "register": continue
            case "ucinewgame": startNewGame()
            case "position": updatePosition(components.map { String($0) })

            case "go": think()
            case "stop": selectMove()

            case "ponderhit": continue
            case "quit": continue

            default: continue
            }
        }

        exit(0)
    }

    private func identifyEngine() {
        sendMessage("id name SwiftChess")
        sendMessage("id author Pete Biencourt")
        sendMessage("uciok")
    }

    private func startNewGame() {
        position = BitBoard()
    }

    private func updatePosition(_ components: [String]) {
        var last = 1
        if components[1] == "startPos" {
            startNewGame()
        } else if components[1] == "fen" {
            let fen = components[2...7].joined(separator: " ")
            last = 7
            position = BitBoard(from: fen)
        }

        last += 1
        if last < components.count, components[last] == "moves" {
            components[(last + 1)...].forEach {
                position.playLongAlgebraicMove($0)
            }
        }

        moveSelector.update(position: position)
    }

    private func think() {
        moveSelector.beginSearch {
            sendMessage($0)
        } completion: { move in
            guard let move = move else { return }
            send(move: move)
        }
    }

    private func selectMove() {
        guard let move = moveSelector.selectMove() else { return }
        send(move: move)
    }

    private func send(move: Move) {
        let notation = move.longAlgebraicNotation(color: position.turnToMove)
        sendMessage("bestmove \(notation)")
    }

    public func testSpeed(n: Int) {
        let evaluator = BasicEvaluator()
        let move = Move.quiet(from: .e2, to: .e4)

        for i in 0 ..< n {
            position.make(move: move)
            _ = evaluator.evaluate(position: position)
            position.unmake(move: move)
            print(i)
        }
    }
}
