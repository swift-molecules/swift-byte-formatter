extension Byte.Size.Scale {

    public struct Tier {

        public let exponent: Int

        public let symbol: String

        @inlinable
        public init(exponent: Int, symbol: String) {
            self.exponent = exponent
            self.symbol = symbol
        }
    }
}

extension Byte.Size.Scale.Tier: Sendable {}
extension Byte.Size.Scale.Tier: Equatable {}
extension Byte.Size.Scale.Tier: Hashable {}
