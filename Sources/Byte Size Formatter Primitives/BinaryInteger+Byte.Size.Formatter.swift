// BinaryInteger+Byte.Size.Formatter.swift
// Consumer entry points for human-readable byte-size formatting.

public import Formatter_Primitives

extension BinaryInteger {
    /// Renders this byte count as a human-readable storage magnitude using the
    /// given byte-size formatter.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let scale = Byte.Size.Scale(
    ///     base: 1000, unitSymbol: "B",
    ///     tiers: [.init(exponent: 1, symbol: "k"), .init(exponent: 2, symbol: "M")]
    /// )
    /// 1500.formatted(Byte.Size.Formatter(scale: scale))   // "1.5 kB"
    /// ```
    ///
    /// - Parameter format: The byte-size formatter to apply.
    /// - Returns: The human-readable size representation.
    @inlinable
    public func formatted(_ format: Byte.Size.Formatter<Self>) -> String {
        format.format(self)
    }

    /// Renders this byte count using any formatter whose input is this integer
    /// type.
    ///
    /// Generic counterpart that lets user-defined
    /// `Formatter.Protocol<Self, _, Never>` conformers participate in the same
    /// call-site API.
    ///
    /// - Parameter format: A formatter whose input is `Self`.
    /// - Returns: The formatter's output.
    @inlinable
    public func formatted<F>(_ format: F) -> F.Output
    where F: Formatter_Primitives.Formatter.`Protocol`, F.Input == Self, F.Failure == Never {
        format.format(self)
    }
}
