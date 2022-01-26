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
            if current & 1 == 1 {
                body(index)
            }

            current >>= 1
            index += 1
        }
    }
}
