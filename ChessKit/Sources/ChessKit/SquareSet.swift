public struct SquareSet: OptionSet {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public init(index: SquareIndex) {
        self.rawValue = 1 << index.rawValue
    }

    public static let a1 = SquareSet(rawValue: 1 << 0)
    public static let b1 = SquareSet(rawValue: 1 << 1)
    public static let c1 = SquareSet(rawValue: 1 << 2)
    public static let d1 = SquareSet(rawValue: 1 << 3)
    public static let e1 = SquareSet(rawValue: 1 << 4)
    public static let f1 = SquareSet(rawValue: 1 << 5)
    public static let g1 = SquareSet(rawValue: 1 << 6)
    public static let h1 = SquareSet(rawValue: 1 << 7)
    public static let a2 = SquareSet(rawValue: 1 << 8)
    public static let b2 = SquareSet(rawValue: 1 << 9)
    public static let c2 = SquareSet(rawValue: 1 << 10)
    public static let d2 = SquareSet(rawValue: 1 << 11)
    public static let e2 = SquareSet(rawValue: 1 << 12)
    public static let f2 = SquareSet(rawValue: 1 << 13)
    public static let g2 = SquareSet(rawValue: 1 << 14)
    public static let h2 = SquareSet(rawValue: 1 << 15)
    public static let a3 = SquareSet(rawValue: 1 << 16)
    public static let b3 = SquareSet(rawValue: 1 << 17)
    public static let c3 = SquareSet(rawValue: 1 << 18)
    public static let d3 = SquareSet(rawValue: 1 << 19)
    public static let e3 = SquareSet(rawValue: 1 << 20)
    public static let f3 = SquareSet(rawValue: 1 << 21)
    public static let g3 = SquareSet(rawValue: 1 << 22)
    public static let h3 = SquareSet(rawValue: 1 << 23)
    public static let a4 = SquareSet(rawValue: 1 << 24)
    public static let b4 = SquareSet(rawValue: 1 << 25)
    public static let c4 = SquareSet(rawValue: 1 << 26)
    public static let d4 = SquareSet(rawValue: 1 << 27)
    public static let e4 = SquareSet(rawValue: 1 << 28)
    public static let f4 = SquareSet(rawValue: 1 << 29)
    public static let g4 = SquareSet(rawValue: 1 << 30)
    public static let h4 = SquareSet(rawValue: 1 << 31)
    public static let a5 = SquareSet(rawValue: 1 << 32)
    public static let b5 = SquareSet(rawValue: 1 << 33)
    public static let c5 = SquareSet(rawValue: 1 << 34)
    public static let d5 = SquareSet(rawValue: 1 << 35)
    public static let e5 = SquareSet(rawValue: 1 << 36)
    public static let f5 = SquareSet(rawValue: 1 << 37)
    public static let g5 = SquareSet(rawValue: 1 << 38)
    public static let h5 = SquareSet(rawValue: 1 << 39)
    public static let a6 = SquareSet(rawValue: 1 << 40)
    public static let b6 = SquareSet(rawValue: 1 << 41)
    public static let c6 = SquareSet(rawValue: 1 << 42)
    public static let d6 = SquareSet(rawValue: 1 << 43)
    public static let e6 = SquareSet(rawValue: 1 << 44)
    public static let f6 = SquareSet(rawValue: 1 << 45)
    public static let g6 = SquareSet(rawValue: 1 << 46)
    public static let h6 = SquareSet(rawValue: 1 << 47)
    public static let a7 = SquareSet(rawValue: 1 << 48)
    public static let b7 = SquareSet(rawValue: 1 << 49)
    public static let c7 = SquareSet(rawValue: 1 << 50)
    public static let d7 = SquareSet(rawValue: 1 << 51)
    public static let e7 = SquareSet(rawValue: 1 << 52)
    public static let f7 = SquareSet(rawValue: 1 << 53)
    public static let g7 = SquareSet(rawValue: 1 << 54)
    public static let h7 = SquareSet(rawValue: 1 << 55)
    public static let a8 = SquareSet(rawValue: 1 << 56)
    public static let b8 = SquareSet(rawValue: 1 << 57)
    public static let c8 = SquareSet(rawValue: 1 << 58)
    public static let d8 = SquareSet(rawValue: 1 << 59)
    public static let e8 = SquareSet(rawValue: 1 << 60)
    public static let f8 = SquareSet(rawValue: 1 << 61)
    public static let g8 = SquareSet(rawValue: 1 << 62)
    public static let h8 = SquareSet(rawValue: 1 << 63)

    public static let none = SquareSet([])
    public static let all = SquareSet(rawValue: ~0)

    public static let aFile = SquareSet([.a1, .a2, .a3, .a4, .a5, .a6, .a7, .a8])
    public static let hFile = SquareSet([.h1, .h2, .h3, .h4, .h5, .h6, .h7, .h8])

    public static let rank1 = SquareSet([.a1, .b1, .c1, .d1, .e1, .f1, .g1, .h1])
    public static let rank2 = SquareSet([.a2, .b2, .c2, .d2, .e2, .f2, .g2, .h2])
    public static let rank3 = SquareSet([.a3, .b3, .c3, .d3, .e3, .f3, .g3, .h3])
    public static let rank4 = SquareSet([.a4, .b4, .c4, .d4, .e4, .f4, .g4, .h4])
    public static let rank5 = SquareSet([.a5, .b5, .c5, .d5, .e5, .f5, .g5, .h5])
    public static let rank6 = SquareSet([.a6, .b6, .c6, .d6, .e6, .f6, .g6, .h6])
    public static let rank7 = SquareSet([.a7, .b7, .c7, .d7, .e7, .f7, .g7, .h7])
    public static let rank8 = SquareSet([.a8, .b8, .c8, .d8, .e8, .f8, .g8, .h8])

    @discardableResult
    public mutating func insert(value: RawValue) -> (inserted: Bool, memberAfterInsert: SquareSet) {
        let newMember = SquareSet(rawValue: value)
        return insert(newMember)
    }

    @discardableResult
    public mutating func insert(square: SquareIndex) -> (inserted: Bool, memberAfterInsert: SquareSet) {
        let newMember = SquareSet(index: square)
        return insert(newMember)
    }

    public func shifted(by places: Int) -> SquareSet {
        precondition(-64 < places && places < 64,
                     "Cannot shift more than 63 times in either direction")

        if places < 0 {
            return SquareSet(rawValue: self.rawValue >> abs(places))
        }

        return SquareSet(rawValue: self.rawValue << places)
    }

    public func forEach(_ body: (SquareSet) -> ()) {
        rawValue.forEach {
            body(SquareSet(rawValue: 1 << $0))
        }
    }

    public func count() -> Int {
        var count = 0
        rawValue.forEach { _ in
            count += 1
        }

        return count
    }
}

extension SquareSet: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        rawValue = value
    }
}

extension SquareSet: CustomStringConvertible {
    public var description: String {
        var squares = [SquareIndex]()
        self.rawValue.forEach {
            squares.append(SquareIndex(rawValue: $0)!)
        }

        if squares.count == 0 {
            return ""
        }

        if squares.count == 1 {
            return "\(squares[0])"
        }

        return "\(squares)"
    }
}
