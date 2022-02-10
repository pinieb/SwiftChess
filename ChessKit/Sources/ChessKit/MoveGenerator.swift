class MoveGenerator {
    private static let knightMoves: [SquareSet] = [
        132096, 329728, 659712, 1319424, 2638848, 5277696, 10489856, 4202496,
        33816580, 84410376, 168886289, 337772578, 675545156, 1351090312, 2685403152, 1075839008,
        8657044482, 21609056261, 43234889994, 86469779988, 172939559976, 345879119952, 687463207072, 275414786112,
        2216203387392, 5531918402816, 11068131838464, 22136263676928, 44272527353856, 88545054707712, 175990581010432, 70506185244672,
        567348067172352, 1416171111120896, 2833441750646784, 5666883501293568, 11333767002587136, 22667534005174272, 45053588738670592, 18049583422636032,
        145241105196122112, 362539804446949376, 725361088165576704, 1450722176331153408, 2901444352662306816, 5802888705324613632, -6913025356609880064, 4620693356194824192
        , 288234782788157440, 576469569871282176, 1224997833292120064, 2449995666584240128, 4899991333168480256, -8646761407372591104, 1152939783987658752, 2305878468463689728,
        1128098930098176, 2257297371824128, 4796069720358912, 9592139440717824, 19184278881435648, 38368557762871296, 4679521487814656, 9077567998918656
    ]

    static let bishopMoves: [[SquareSet]] = [
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 4, 8, 16, 32, 64, 0, 256, 513, 1026, 2052, 4104, 8208, 16416, 0, 65536, 131328, 262657, 525314, 1050628, 2101256, 4202512, 0, 16777216, 33619968, 67240192, 134480385, 268960770, 537921540, 1075843080, 0, 4294967296, 8606711808, 17213489152, 34426978560, 68853957121, 137707914242, 275415828484, 0, 1099511627776, 2203318222848, 4406653222912, 8813306511360, 17626613022976, 35253226045953, 70506452091906, 0, 281474976710656, 564049465049088, 1128103225065472, 2256206466908160, 4512412933881856, 9024825867763968, 18049651735527937], [0, 0, 0, 0, 0, 0, 0, 0, 2, 4, 8, 16, 32, 64, 128, 0, 516, 1032, 2064, 4128, 8256, 16512, 32768, 0, 132104, 264208, 528416, 1056832, 2113664, 4227072, 8388608, 0, 33818640, 67637280, 135274560, 270549120, 541097984, 1082130432, 2147483648, 0, 8657571872, 17315143744, 34630287488, 69260574720, 138521083904, 277025390592, 549755813888, 0, 2216338399296, 4432676798592, 8865353596928, 17730707128320, 35461397479424, 70918499991552, 140737488355328, 0, 567382630219904, 1134765260439552, 2269530520813568, 4539061024849920, 9078117754732544, 18155135997837312, 36028797018963968, 0], [0, 256, 66048, 16909312, 4328785920, 1108169199616, 283691315109888, 72624976668147712, 0, 65536, 16908288, 4328783872, 1108169195520, 283691315101696, 72624976668131328, 145249953336262656, 0, 16777216, 4328521728, 1108168671232, 283691314053120, 72624976666034176, 145249953332068352, 290499906664136704, 0, 4294967296, 1108101562368, 283691179835392, 72624976397598720, 145249952795197440, 290499905590394880, 580999811180789760, 0, 1099511627776, 283673999966208, 72624942037860352, 145249884075720704, 290499768151441408, 580999536302882816, 1161999072605765632, 0, 281474976710656, 72620543991349248, 145241087982698496, 290482175965396992, 580964351930793984, 1161928703861587968, 2323857407723175936, 0, 72057594037927936, 144115188075855872, 288230376151711744, 576460752303423488, 1152921504606846976, 2305843009213693952, 4611686018427387904, 0, 0, 0, 0, 0, 0, 0, 0], [-9205322385119247872, 36099303471055872, 141012904183808, 550831656960, 2151686144, 8404992, 32768, 0, 4620710844295151616, -9205322385119248384, 36099303471054848, 141012904181760, 550831652864, 2151677952, 8388608, 0, 2310355422147510272, 4620710844295020544, -9205322385119510528, 36099303470530560, 141012903133184, 550829555712, 2147483648, 0, 1155177711056977920, 2310355422113955840, 4620710844227911680, -9205322385253728256, 36099303202095104, 141012366262272, 549755813888, 0, 577588851233521664, 1155177702467043328, 2310355404934086656, 4620710809868173312, -9205322453973204992, 36099165763141632, 140737488355328, 0, 288793326105133056, 577586652210266112, 1155173304420532224, 2310346608841064448, 4620693217682128896, -9205357638345293824, 36028797018963968, 0, 144115188075855872, 288230376151711744, 576460752303423488, 1152921504606846976, 2305843009213693952, 4611686018427387904, -9223372036854775808, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    ]

    static let rookMoves: [[SquareSet]] = [
        [254, 252, 248, 240, 224, 192, 128, 0, 65024, 64512, 63488, 61440, 57344, 49152, 32768, 0, 16646144, 16515072, 16252928, 15728640, 14680064, 12582912, 8388608, 0, 4261412864, 4227858432, 4160749568, 4026531840, 3758096384, 3221225472, 2147483648, 0, 1090921693184, 1082331758592, 1065151889408, 1030792151040, 962072674304, 824633720832, 549755813888, 0, 279275953455104, 277076930199552, 272678883688448, 263882790666240, 246290604621824, 211106232532992, 140737488355328, 0, 71494644084506624, 70931694131085312, 69805794224242688, 67553994410557440, 63050394783186944, 54043195528445952, 36028797018963968, 0, -144115188075855872, -288230376151711744, -576460752303423488, -1152921504606846976, -2305843009213693952, -4611686018427387904, -9223372036854775808, 0], [72340172838076672, 144680345676153344, 289360691352306688, 578721382704613376, 1157442765409226752, 2314885530818453504, 4629771061636907008, -9187201950435737600, 72340172838076416, 144680345676152832, 289360691352305664, 578721382704611328, 1157442765409222656, 2314885530818445312, 4629771061636890624, -9187201950435770368, 72340172838010880, 144680345676021760, 289360691352043520, 578721382704087040, 1157442765408174080, 2314885530816348160, 4629771061632696320, -9187201950444158976, 72340172821233664, 144680345642467328, 289360691284934656, 578721382569869312, 1157442765139738624, 2314885530279477248, 4629771060558954496, -9187201952591642624, 72340168526266368, 144680337052532736, 289360674105065472, 578721348210130944, 1157442696420261888, 2314885392840523776, 4629770785681047552, -9187202502347456512, 72339069014638592, 144678138029277184, 289356276058554368, 578712552117108736, 1157425104234217472, 2314850208468434944, 4629700416936869888, -9187343239835811840, 72057594037927936, 144115188075855872, 288230376151711744, 576460752303423488, 1152921504606846976, 2305843009213693952, 4611686018427387904, -9223372036854775808, 0, 0, 0, 0, 0, 0, 0, 0], [0, 1, 3, 7, 15, 31, 63, 127, 0, 256, 768, 1792, 3840, 7936, 16128, 32512, 0, 65536, 196608, 458752, 983040, 2031616, 4128768, 8323072, 0, 16777216, 50331648, 117440512, 251658240, 520093696, 1056964608, 2130706432, 0, 4294967296, 12884901888, 30064771072, 64424509440, 133143986176, 270582939648, 545460846592, 0, 1099511627776, 3298534883328, 7696581394432, 16492674416640, 34084860461056, 69269232549888, 139637976727552, 0, 281474976710656, 844424930131968, 1970324836974592, 4222124650659840, 8725724278030336, 17732923532771328, 35747322042253312, 0, 72057594037927936, 216172782113783808, 504403158265495552, 1080863910568919040, 2233785415175766016, 4539628424389459968, 9151314442816847872], [0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 4, 8, 16, 32, 64, 128, 257, 514, 1028, 2056, 4112, 8224, 16448, 32896, 65793, 131586, 263172, 526344, 1052688, 2105376, 4210752, 8421504, 16843009, 33686018, 67372036, 134744072, 269488144, 538976288, 1077952576, 2155905152, 4311810305, 8623620610, 17247241220, 34494482440, 68988964880, 137977929760, 275955859520, 551911719040, 1103823438081, 2207646876162, 4415293752324, 8830587504648, 17661175009296, 35322350018592, 70644700037184, 141289400074368, 282578800148737, 565157600297474, 1130315200594948, 2260630401189896, 4521260802379792, 9042521604759584, 18085043209519168, 36170086419038336]
    ]

    static func generateMoves(from position: BitBoard) -> [Move] {
        var moves = [Move]()

        moves.append(contentsOf: pawnMoves(color: position.turnToMove,
                                           pieces: position.pieces,
                                           enPassant: position.enPassant))

        moves.append(contentsOf: knightMoves(color: position.turnToMove,
                                             pieces: position.pieces))

        moves.append(contentsOf: diagonalSliderMoves(color: position.turnToMove,
                                                     pieces: position.pieces))

        moves.append(contentsOf: orthogonalSliderMoves(color: position.turnToMove,
                                                       pieces: position.pieces))

        if !position.attackedSquares[position.turnToMove].contains(position.pieces[position.turnToMove, .king]) {
            moves.append(contentsOf: castles(color: position.turnToMove,
                                             position: position))
        }

        return moves
    }

    static func pawnMoves(color: Color,
                          pieces: PieceCollection,
                          enPassant: SquareSet) -> [Move] {
        var moves = [Move]()
        pieces[color, .pawn].forEach { source in
            moves.append(contentsOf: pawnPushes(color: color,
                                                pieces: pieces,
                                                source: source))

            moves.append(contentsOf: pawnCaptures(color: color,
                                                  pieces: pieces,
                                                  source: source))

            moves.append(contentsOf: enPassantCaptures(color: color,
                                                       pieces: pieces,
                                                       enPassant: enPassant))
        }

        return moves
    }

    private static func pawnPushes(color: Color,
                                   pieces: PieceCollection,
                                   source: SquareSet) -> [Move] {
        let shift = color == .white ? 8 : -8

        let singlePush = source.shifted(by: shift)
        guard !pieces.all.contains(singlePush) else { return [] }

        var moves = [Move.quiet(from: source,
                                to: singlePush)]

        // If we're on the starting rank, we can double push
        let startingRank = color == .white ? SquareSet.rank2 : SquareSet.rank7
        guard startingRank.contains(source) else {
            return moves
        }

        let doublePush = singlePush.shifted(by: shift)
        if !pieces.all.contains(doublePush) {
            moves.append(.quiet(from: source,
                                to: doublePush))
        }

        return moves
    }

    private static func pawnCaptures(color: Color,
                                     pieces: PieceCollection,
                                     source: SquareSet) -> [Move] {
        let left = source.shifted(by: color == .white ? 7 : -7)
        let right = source.shifted(by: color == .white ? 9 : -9)

        var moves = [Move]()
        if !SquareSet.aFile.contains(source),
            pieces[color.opponent].contains(left) {
            moves.append(.capture(from: source,
                                  to: left))
        }

        if !SquareSet.hFile.contains(source),
           pieces[color.opponent].contains(right) {
            moves.append(.capture(from: source,
                                  to: right))
        }

        return moves
    }

    private static func enPassantCaptures(color: Color,
                                          pieces: PieceCollection,
                                          enPassant: SquareSet) -> [Move] {
        let left = enPassant.shifted(by: color == .white ? -7 : 7)
        let right = enPassant.shifted(by: color == .white ? -9 : 9)

        var moves = [Move]()

        if !SquareSet.aFile.contains(enPassant),
           pieces[color, .pawn].contains(left) {
            moves.append(.enPassant(from: left,
                                    to: enPassant))
        }

        if !SquareSet.hFile.contains(enPassant),
           pieces[color, .pawn].contains(right) {
            moves.append(.enPassant(from: right,
                                    to: enPassant))
        }

        return moves
    }

    private static func knightMoves(color: Color,
                                    pieces: PieceCollection) -> [Move] {
        var moves = [Move]()
        pieces[color, .knight].forEach { source in
            guard let sourceIndex = SquareIndex(rawValue: source.rawValue.first!) else {
                return
            }

            var targets = knightMoves[sourceIndex.rawValue]
            targets.remove(pieces[color])

            targets.forEach { target in
                if pieces[color.opponent].contains(target) {
                    moves.append(.capture(from: source,
                                          to: target))
                } else {
                    moves.append(.quiet(from: source,
                                        to: target))
                }
            }
        }

        return moves
    }

    private static func diagonalSliderMoves(color: Color,
                                            pieces: PieceCollection) -> [Move] {
        var moves = [Move]()

        let sliders = pieces[color, .bishop].union(pieces[color, .queen])

        sliders.forEach { source in
            guard let sourceIndex = SquareIndex(rawValue: source.rawValue.first!) else {
                return
            }

            for direction in 0 ..< 4 {
                let blockedSquares = pieces.all.intersection(bishopMoves[direction][sourceIndex.rawValue])

                var firstHit: Int?
                if direction < 2 {
                    firstHit = blockedSquares.rawValue.first
                } else {
                    firstHit = blockedSquares.rawValue.last
                }

                var availableSquares = bishopMoves[direction][sourceIndex.rawValue]
                if let firstHit = firstHit {
                    availableSquares.remove(bishopMoves[direction][firstHit])
                    availableSquares.remove(pieces[color])
                }

                availableSquares.forEach { target in
                    guard !pieces[color.opponent].contains(target) else {
                        moves.append(.capture(from: source,
                                              to: target))
                        return
                    }

                    moves.append(.quiet(from: source,
                                        to: target))
                }
            }
        }

        return moves
    }

    private static func orthogonalSliderMoves(color: Color,
                                              pieces: PieceCollection) -> [Move] {
        var moves = [Move]()

        let sliders = pieces[color, .rook].union(pieces[color, .queen])
        sliders.forEach { source in
            guard let sourceIndex = SquareIndex(rawValue: source.rawValue.first!) else {
                return
            }

            for direction in 0 ..< 4 {
                let blockedSquares = pieces.all.intersection(rookMoves[direction][sourceIndex.rawValue])

                var firstHit: Int?
                if direction < 2 {
                    firstHit = blockedSquares.rawValue.first
                } else {
                    firstHit = blockedSquares.rawValue.last
                }

                var availableSquares = bishopMoves[direction][sourceIndex.rawValue]
                if let firstHit = firstHit {
                    availableSquares.remove(bishopMoves[direction][firstHit])
                    availableSquares.remove(pieces[color])
                }

                availableSquares.forEach { target in
                    guard !pieces[color.opponent].contains(target) else {
                        moves.append(.capture(from: source,
                                              to: target))
                        return
                    }

                    moves.append(.quiet(from: source,
                                        to: target))
                }
            }
        }

        return moves
    }

    public static func castles(color: Color,
                               position: BitBoard) -> [Move] {
        var moves = [Move]()

        let kingSquare: SquareSet = color == .white ? [.e1] : [.e8]
        let kingsideSquares: SquareSet = color == .white ? [.f1, .g1] : [.f8, .g8]
        let queensideSquares: SquareSet = color == .white ? [.b1, .c1, .d1] : [.b8, .c8, .d8]

        let dangerSquares = position.kingDangerSquares[color]

        if (position.states.last?.castlingRights.contains(.kingside) ?? false),
           position.pieces.all.intersection(kingsideSquares) == .none,
           dangerSquares.intersection([kingSquare, kingsideSquares]) == .none {
            moves.append(.castle(.kingside))
        }

        if position.states.last?.castlingRights.contains(.queenside) ?? false,
           position.pieces.all.intersection(queensideSquares) == .none,
           dangerSquares.intersection([kingSquare, queensideSquares]) == .none {
            moves.append(.castle(.queenside))
        }

        return moves
    }
}
