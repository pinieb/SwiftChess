import ChessKit
import Darwin
import QuartzCore

setbuf(__stdoutp, nil)

let moveSelector = IterativeDFSMoveSelector(evaluator: BasicEvaluator(), maxDepth: 2)
var engine = Engine(moveSelector: moveSelector)
engine.run()

//engine.testSpeed(n: 100_000)

//var position = BitBoard()
//position.make(move: .quiet(from: .e2, to: .e4))
//position.make(move: .quiet(from: .a7, to: .a6))
//position.make(move: .capture(from: .f1, to: .a6))
//moveSelector.update(position: position)
//
//let startTime = CACurrentMediaTime()
//moveSelector.beginSearch(outputCallback: { print($0) }) {
//    let interval = CACurrentMediaTime() - startTime
//    NSLog("\(interval)")
//    NSLog("\($0)")
//}

