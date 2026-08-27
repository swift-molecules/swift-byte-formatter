public import Byte
public import Formatter
public import Radix

extension Byte {

    public struct Formatter: Sendable, Formatter::Formatter.`Protocol` {

        @usableFromInline
        let radix: Radix

        @inlinable
        public init(radix: Radix = .hexadecimal) {
            self.radix = radix
        }
    }
}

extension Byte.Formatter {

    public typealias Input = Byte

    public typealias Output = String

    public typealias Failure = Never

    @inlinable
    public func format(_ value: Byte) -> String {
        let base = radix.base

        var width = 1
        var ceiling = Int(UInt8.max)
        while ceiling >= base {
            ceiling /= base
            width += 1
        }

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

extension Byte.Formatter {

    public static let hexadecimal = Self(radix: .hexadecimal)
}
