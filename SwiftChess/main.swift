import ChessKit
import Darwin
import QuartzCore

setbuf(__stdoutp, nil)

let moveSelector = AsyncMinimaxMoveSelector(evaluator: BasicEvaluator(),
                                            maxDepth: 3,
                                            threads: 4)
var engine = Engine(moveSelector: moveSelector)
engine.run()

//engine.testSpeed(n: 100_000)
//
//var position = BitBoard(from: "Nnb2bnr/p3kppp/2p5/4p3/2B5/1P3N2/q1PP1PPP/2BQK2R b K - 1 10")
//position.make(move: .quiet(from: .e2, to: .e4))
//position.make(move: .quiet(from: .a7, to: .a6))
//position.make(move: .capture(from: .f1, to: .a6))
//moveSelector.update(position: position)
//
//print(position)
//
//let startTime = CACurrentMediaTime()
//moveSelector.beginSearch(outputCallback: { print($0) }) {
//    let interval = CACurrentMediaTime() - startTime
//    print("\(interval)")
//    print("\($0)")
//}

