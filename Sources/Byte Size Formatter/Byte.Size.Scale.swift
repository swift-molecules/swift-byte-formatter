extension Byte.Size {

    public struct Scale {

        public let base: Int

        public let unitSymbol: String

        public let tiers: [Tier]

        @inlinable
        public init(base: Int, unitSymbol: String, tiers: [Tier]) {
            precondition(base >= 2, "byte-size scale base must be at least 2")
            self.base = base
            self.unitSymbol = unitSymbol
            self.tiers = tiers
        }
    }
}

extension Byte.Size.Scale: Sendable {}
extension Byte.Size.Scale: Equatable {}
extension Byte.Size.Scale: Hashable {}
