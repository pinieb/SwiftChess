public extension Array {
    subscript<Index: RawRepresentable>(_ index: Index) -> Element where Index.RawValue == Int {
        get {
            return self[index.rawValue]
        }
        set {
            self[index.rawValue] = newValue
        }
    }
}
