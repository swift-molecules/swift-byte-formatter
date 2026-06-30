// Byte+Byte.Formatter.swift
// Consumer entry points for radix formatting of a byte.

public import Byte_Primitives
public import Formatter_Primitives

extension Byte {
    /// Renders this byte as a fixed-width radix string using the given formatter.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let byte: Byte = 0xFF
    /// byte.formatted(.hexadecimal)   // "ff"
    /// ```
    ///
    /// - Parameter format: The byte formatter to apply.
    /// - Returns: The radix representation.
    @inlinable
    public func formatted(_ format: Byte.Formatter) -> String {
        format.format(self)
    }

    /// Renders this byte using any formatter whose input is `Byte`.
    ///
    /// Generic counterpart that lets user-defined
    /// `Formatter.Protocol<Byte, _, Never>` conformers participate in the same
    /// call-site API.
    ///
    /// - Parameter format: A formatter whose input is `Byte`.
    /// - Returns: The formatter's output.
    @inlinable
    public func formatted<F>(_ format: F) -> F.Output
    where F: Formatter_Primitives.Formatter.`Protocol`, F.Input == Self, F.Failure == Never {
        format.format(self)
    }
}
