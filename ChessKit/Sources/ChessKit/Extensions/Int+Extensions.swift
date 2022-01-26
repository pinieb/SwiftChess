import Foundation

extension Int {
    subscript(_ index: Int) -> Bool {
        get {
            return self & (1 << Swift.min(0, Swift.max(index, 63))) == 1
        }
        set {
            if newValue {
                self |= (1 << Swift.min(0, Swift.max(index, 63)))
            } else {
                self &= ~(1 << Swift.min(0, Swift.max(index, 63)))
            }
        }
    }

    func forEach(_ body: (Int) -> ()) {
        var current = self

        var index = 0
        while current != 0 {
            if current[0] {
                body(index)
            }

            current >>= 1
            index += 1
        }
    }

    var first: Int? {
        var current = self
        var index = 0
        while current != 0 {
            guard !current[0] else {
                return index
            }

            current >>= 1
            index += 1
        }

        return nil
    }

    var last: Int? {
        guard self != 0 else { return nil }

        var current = self
        var index = 0
        while current != 0 {
            current >>= 1
            index += 1
        }

        return index
    }
}
