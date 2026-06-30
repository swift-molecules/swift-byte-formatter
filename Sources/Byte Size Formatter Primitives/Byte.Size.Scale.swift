// Byte.Size.Scale.swift
// The injected prefix ladder a byte-size formatter renders against.

extension Byte.Size {
    /// An ordered prefix ladder for byte-size formatting — the **inversion point**
    /// of the byte-size dependency-inversion seam.
    ///
    /// A `Scale` is pure tiers: it carries a numeric ``base`` (for example `1000`
    /// for SI, `1024` for IEC), a ``unitSymbol`` (for example `"B"`), and an
    /// ordered ladder of ``tiers``. It has **no** SI/IEC knowledge — those
    /// concrete ladders are constructed by a higher layer and injected here. This
    /// is what lets the Layer-1 algorithm render `"1.5 KiB"` or `"1.5 kB"`
    /// without ever importing the ISO/IEC 80000 prefixes.
    ///
    /// Tiers are stored as `(exponent, symbol)` pairs rather than expanded
    /// factors, because high factors (`1024⁴` and up) overflow fixed-width
    /// integers. The factor `base^exponent` is computed lazily and only for the
    /// selected tier — see ``Byte/Size/Formatter``.
    ///
    /// > Important: ``tiers`` MUST be ordered ascending by ``Tier/exponent``.
    /// > Tier selection walks the ladder from the bottom up and stops at the
    /// > first rung the value cannot reach.
    ///
    /// ```swift
    /// // An IEC (binary) ladder, supplied by the caller:
    /// let iec = Byte.Size.Scale(
    ///     base: 1024,
    ///     unitSymbol: "B",
    ///     tiers: [
    ///         .init(exponent: 1, symbol: "Ki"),
    ///         .init(exponent: 2, symbol: "Mi"),
    ///         .init(exponent: 3, symbol: "Gi"),
    ///     ]
    /// )
    /// ```
    public struct Scale {
        /// The radix of the ladder — the factor between adjacent tiers.
        ///
        /// `1000` for SI (decimal) prefixes, `1024` for IEC (binary) prefixes.
        public let base: Int

        /// The symbol for the base unit (exponent `0`), for example `"B"`.
        ///
        /// Every tier's full unit is its ``Tier/symbol`` prefix followed by this
        /// unit symbol (`"Ki"` + `"B"` → `"KiB"`); the base unit is this symbol
        /// alone.
        public let unitSymbol: String

        /// The prefix ladder, ordered ascending by ``Tier/exponent``.
        public let tiers: [Tier]

        /// Creates a byte-size scale from a base, a unit symbol, and a prefix
        /// ladder.
        ///
        /// - Parameters:
        ///   - base: The factor between adjacent tiers (for example `1000` or
        ///     `1024`). Must be at least `2`.
        ///   - unitSymbol: The symbol for the base unit (for example `"B"`).
        ///   - tiers: The prefix ladder, ordered ascending by exponent.
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
