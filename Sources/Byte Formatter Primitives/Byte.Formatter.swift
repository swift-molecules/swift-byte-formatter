// Byte.Formatter.swift
// Radix text rendering of a single byte (hexadecimal by default).

public import Byte_Primitives
public import Formatter_Primitives
public import Radix_Primitive

extension Byte {
    /// A formatter that renders a single ``Byte`` as fixed-width text in a given
    /// ``Radix`` — hexadecimal by default, so `Byte(0xFF)` renders as `"ff"`.
    ///
    /// `Byte.Formatter` conforms to `Formatter.Protocol<Byte, String, Never>`,
    /// letting it participate in the generic `.formatted(_:)` API alongside other
    /// formatters. It takes its digit alphabet from a `Radix`
    /// (`swift-radix-primitives`): the rendered glyphs are exactly
    /// `radix.digit(for:)` of each place value.
    ///
    /// Output is **fixed-width**: the number of digits is the minimum needed to
    /// represent any byte (`0...255`) in the radix's base, with leading zeros
    /// included. Hexadecimal therefore always yields two glyphs (`"0a"`, `"ff"`),
    /// decimal three (`"010"`, `"255"`), binary eight.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let byte: Byte = 0xFF
    /// byte.formatted(.hexadecimal)                 // "ff"
    /// Byte(0x0A).formatted(.hexadecimal)           // "0a"
    /// Byte(255).formatted(Byte.Formatter(radix: .decimal))  // "255"
    /// ```
    public struct Formatter: Sendable, Formatter_Primitives.Formatter.`Protocol` {
        /// The numeral base and digit alphabet used to render the byte.
        @usableFromInline
        let radix: Radix

        /// Creates a byte formatter for the given radix.
        ///
        /// - Parameter radix: The numeral base and digit alphabet. Default
        ///   ``Radix/hexadecimal``.
        @inlinable
        public init(radix: Radix = .hexadecimal) {
            self.radix = radix
        }
    }
}

// MARK: - Formatter.Protocol

extension Byte.Formatter {
    /// The value this formatter accepts: a single byte.
    public typealias Input = Byte

    /// The value this formatter produces: the radix string.
    public typealias Output = String

    /// The error this formatter can raise: `Never` — radix rendering cannot fail.
    public typealias Failure = Never

    /// Renders a byte as its fixed-width radix string.
    ///
    /// Emits the minimum number of digits needed to represent any byte in
    /// ``radix``'s base, most-significant digit first, with leading zeros. Each
    /// glyph is `radix.digit(for:)` of the corresponding place value.
    ///
    /// - Parameter value: The byte to render.
    /// - Returns: The fixed-width radix representation.
    @inlinable
    public func format(_ value: Byte) -> String {
        let base = radix.base

        // Minimum digit count to represent any byte (0...255) in this base.
        var width = 1
        var ceiling = Int(UInt8.max)
        while ceiling >= base {
            ceiling /= base
            width += 1
        }

        // Emit digits least-significant first, then reverse for MSB-first output.
        var glyphs: [Unicode.Scalar] = []
        glyphs.reserveCapacity(width)
        var n = Int(value.underlying)
        repeat {
            glyphs.append(radix.digit(for: n % base) ?? "0")
            n /= base
        } while n > 0
        while glyphs.count < width {
            glyphs.append(radix.digit(for: 0) ?? "0")
        }

        var scalars = String.UnicodeScalarView()
        scalars.append(contentsOf: glyphs.reversed())
        return String(scalars)
    }
}

// MARK: - Styles

extension Byte.Formatter {
    /// Hexadecimal rendering, lower-case, two glyphs per byte (`"ff"`, `"0a"`).
    public static let hexadecimal = Self(radix: .hexadecimal)
}
