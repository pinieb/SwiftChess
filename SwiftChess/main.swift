import ChessKit
import Darwin

setbuf(__stdoutp, nil)

var engine = Engine(moveSelector: RandomMoveSelector())
engine.run()
