// Byte.Size.Formatter.swift
// Generic human-readable byte-size formatter.

public import Formatter_Primitives

extension Byte.Size {
    /// A formatter that renders a count of bytes as a human-readable storage
    /// magnitude — `"1.5 KiB"`, `"1.5 kB"`, `"512 B"` — against an injected
    /// ``Byte/Size/Scale``.
    ///
    /// `Byte.Size.Formatter` is the generic half of the byte-size
    /// dependency-inversion seam. It holds a ``scale`` (the prefix ladder), a
    /// ``precision`` (fractional digits), and a ``separator`` (the gap between
    /// the mantissa and the unit), and conforms to
    /// `Formatter.Protocol<Count, String, Never>` so it participates in the
    /// generic `.formatted(_:)` API alongside every other formatter.
    ///
    /// `Count` is the byte-count integer type (any `BinaryInteger`). The scale
    /// supplies *what* the tiers are; this type supplies *how* a value is mapped
    /// onto them: it selects the largest tier whose `base^exponent` does not
    /// exceed the count, then renders the mantissa and the tier's unit.
    ///
    /// ## Mantissa rendering
    ///
    /// The mantissa (`"1.5"`) is produced by **integer math only** — an integer
    /// part plus ``precision`` fractional digits, each derived by repeated
    /// multiply-and-divide. There is no `Foundation`, no floating point, and no
    /// `String(format:)`. Fractional digits are **truncated** toward zero, not
    /// rounded.
    ///
    /// ## Overflow safety
    ///
    /// Tier selection never materializes `base^exponent` for tiers above the one
    /// chosen — it divides the count down instead, so high tiers (whose factors
    /// overflow fixed-width integers) are never computed. The factor for the
    /// *selected* tier is materialized, which is always safe because it does not
    /// exceed the count being formatted.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let iec = Byte.Size.Scale(
    ///     base: 1024,
    ///     unitSymbol: "B",
    ///     tiers: [.init(exponent: 1, symbol: "Ki"), .init(exponent: 2, symbol: "Mi")]
    /// )
    /// let format = Byte.Size.Formatter<Int>(scale: iec)
    ///
    /// 1536.formatted(format)              // "1.5 KiB"
    /// 512.formatted(format)               // "512.0 B"
    /// (3 * 1024 * 1024).formatted(format) // "3.0 MiB"
    /// ```
    ///
    /// - Parameter Count: The byte-count integer type to format.
    public struct Formatter<Count>: Sendable, Formatter_Primitives.Formatter.`Protocol`
    where Count: BinaryInteger {
        /// The injected prefix ladder this formatter renders against.
        @usableFromInline
        let scale: Byte.Size.Scale

        /// The number of fractional digits in the mantissa.
        @usableFromInline
        let precision: Int

        /// The string inserted between the mantissa and the unit symbol.
        @usableFromInline
        let separator: String

        /// Creates a byte-size formatter bound to a scale.
        ///
        /// - Parameters:
        ///   - scale: The prefix ladder to render against.
        ///   - precision: The number of fractional digits in the mantissa. Must
        ///     be non-negative. Default `1`.
        ///   - separator: The string inserted between the mantissa and the unit
        ///     symbol. Default `" "`.
        @inlinable
        public init(scale: Byte.Size.Scale, precision: Int = 1, separator: String = " ") {
            precondition(precision >= 0, "precision must be non-negative")
            self.scale = scale
            self.precision = precision
            self.separator = separator
        }
    }
}

// MARK: - Formatter.Protocol

extension Byte.Size.Formatter {
    /// The value this formatter accepts: a count of bytes.
    public typealias Input = Count

    /// The value this formatter produces: the human-readable size string.
    public typealias Output = String

    /// The error this formatter can raise: `Never` — size rendering cannot fail.
    public typealias Failure = Never

    /// Renders a byte count as its human-readable storage magnitude.
    ///
    /// Selects the largest tier whose `base^exponent` does not exceed the
    /// magnitude of `value`, then renders the mantissa (truncated to
    /// ``precision`` fractional digits) followed by ``separator`` and the tier's
    /// full unit. Negative counts render with a leading `"-"`.
    ///
    /// - Parameter value: The byte count to render.
    /// - Returns: The human-readable size representation.
    @inlinable
    public func format(_ value: Count) -> String {
        let negative = value < 0
        let magnitude = value.magnitude
        let base = Count.Magnitude(scale.base)

        // Select the largest tier whose base^exponent <= magnitude, by repeated
        // division — overflow-safe: base^exponent is never materialized for any
        // tier above the one chosen.
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

        // Materialize base^exponent for the chosen tier only. Safe: it does not
        // exceed `magnitude`.
        let exponent = chosen?.exponent ?? 0
        var divisor = Count.Magnitude(1)
        var step = 0
        while step < exponent {
            divisor *= base
            step += 1
        }

        // Mantissa via integer math — integer part plus `precision` truncated
        // fractional digits. No floating point, no Foundation.
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
