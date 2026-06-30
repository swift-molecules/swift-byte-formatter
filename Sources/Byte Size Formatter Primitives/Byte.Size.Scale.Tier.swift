// Byte.Size.Scale.Tier.swift
// One rung of a byte-size prefix ladder.

extension Byte.Size.Scale {
    /// One rung of a byte-size prefix ladder: a power of the scale's base paired
    /// with the symbol that names it.
    ///
    /// A tier is modelled as an `(exponent, symbol)` pair rather than an expanded
    /// factor. Storing the *exponent* — not the factor — is deliberate: the
    /// factor for a high tier (for example `1024⁴` for a tebibyte, or `1000⁸`)
    /// overflows fixed-width integers, so the factor `base^exponent` is computed
    /// lazily and only ever for the tier actually selected (which, by
    /// construction, never exceeds the value being formatted).
    ///
    /// The ``symbol`` is the **prefix** that precedes the scale's
    /// ``Byte/Size/Scale/unitSymbol`` — for example `"Ki"` (which renders as
    /// `"KiB"` alongside a `"B"` unit) or `"k"` (which renders as `"kB"`). The
    /// base unit itself (exponent `0`) has no tier; it is the bare unit symbol.
    public struct Tier {
        /// The power of the scale's base this tier represents.
        ///
        /// Tier `n` covers values in `base^n ..< base^(n+1)`. Exponents are
        /// `1`-based — exponent `0` is the bare unit and has no tier.
        public let exponent: Int

        /// The prefix symbol naming this tier (for example `"Ki"`, `"M"`).
        ///
        /// Rendered immediately before the scale's
        /// ``Byte/Size/Scale/unitSymbol`` to spell the full unit (`"Ki"` + `"B"`
        /// → `"KiB"`).
        public let symbol: String

        /// Creates a prefix-ladder tier.
        ///
        /// - Parameters:
        ///   - exponent: The power of the scale's base this tier represents.
        ///     Must be positive.
        ///   - symbol: The prefix symbol naming this tier.
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
