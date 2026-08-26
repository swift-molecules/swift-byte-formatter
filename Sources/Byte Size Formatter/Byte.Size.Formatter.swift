public import Formatter

extension Byte.Size {

    public struct Formatter<Count>: Sendable, Formatter.Formatter.`Protocol`
    where Count: BinaryInteger {

        @usableFromInline
        let scale: Byte.Size.Scale

        @usableFromInline
        let precision: Int

        @usableFromInline
        let separator: String

        @inlinable
        public init(scale: Byte.Size.Scale, precision: Int = 1, separator: String = " ") {
            precondition(precision >= 0, "precision must be non-negative")
            self.scale = scale
            self.precision = precision
            self.separator = separator
        }
    }
}

extension Byte.Size.Formatter {

    public typealias Input = Count

    public typealias Output = String

    public typealias Failure = Never

    @inlinable
    public func format(_ value: Count) -> String {
        let negative = value < 0
        let magnitude = value.magnitude
        let base = Count.Magnitude(scale.base)

        var chosen: Byte.Size.Scale.Tier?
        for tier in scale.tiers {
            var probe = magnitude
            var step = 0
            while step < tier.exponent {
                probe /= base
                step += 1
            }
            guard probe >= 1 else { break }
            chosen = tier
        }

        let exponent = chosen?.exponent ?? 0
        var divisor = Count.Magnitude(1)
        var step = 0
        while step < exponent {
            divisor *= base
            step += 1
        }

        let integerPart = magnitude / divisor
        var mantissa = String(integerPart, radix: 10)
        if precision > 0 {
            mantissa += "."
            var remainder = magnitude % divisor
            var digit = 0
            while digit < precision {
                remainder *= 10
                mantissa += String(remainder / divisor, radix: 10)
                remainder %= divisor
                digit += 1
            }
        }

        let unit = (chosen?.symbol ?? "") + scale.unitSymbol
        return (negative ? "-" : "") + mantissa + separator + unit
    }
}
