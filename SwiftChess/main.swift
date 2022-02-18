import ChessKit
import Darwin

setbuf(__stdoutp, nil)

let moveSelector = GreedyMoveSelector(evaluator: BasicEvaluator())
var engine = Engine(moveSelector: moveSelector)
engine.run()

