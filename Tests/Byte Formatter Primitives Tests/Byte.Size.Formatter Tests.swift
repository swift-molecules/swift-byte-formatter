import Testing

@testable import Byte_Formatter_Primitives

// Test ladders. These stand in for the SI/IEC ladders an L2 binding would
// inject — this package itself carries no SI/IEC knowledge.

private let decimal = Byte.Size.Scale(
    base: 1000,
    unitSymbol: "B",
    tiers: [
        .init(exponent: 1, symbol: "k"),
        .init(exponent: 2, symbol: "M"),
        .init(exponent: 3, symbol: "G"),
    ]
)

private let iec = Byte.Size.Scale(
    base: 1024,
    unitSymbol: "B",
    tiers: [
        .init(exponent: 1, symbol: "Ki"),
        .init(exponent: 2, symbol: "Mi"),
        .init(exponent: 3, symbol: "Gi"),
    ]
)

// MARK: - Byte.Size.Formatter — Decimal (base 1000)

@Suite
struct `Byte.Size.Formatter - Decimal` {

    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}

    @Test
    func `Renders kilobytes with one fractional digit`() {
        #expect(1500.formatted(Byte.Size.Formatter(scale: decimal)) == "1.5 kB")
    }

    @Test
    func `Renders megabytes`() {
        #expect(1_500_000.formatted(Byte.Size.Formatter(scale: decimal)) == "1.5 MB")
    }

    @Test
    func `Renders gigabytes`() {
        #expect(2_000_000_000.formatted(Byte.Size.Formatter(scale: decimal)) == "2.0 GB")
    }

    @Test
    func `Values below the first tier render in the base unit`() {
        #expect(500.formatted(Byte.Size.Formatter(scale: decimal)) == "500.0 B")
    }

    @Test
    func `Exactly one base renders 1.0 of the first tier`() {
        #expect(1000.formatted(Byte.Size.Formatter(scale: decimal)) == "1.0 kB")
    }
}

// MARK: - Byte.Size.Formatter — IEC (base 1024)

@Suite
struct `Byte.Size.Formatter - IEC` {

    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}

    @Test
    func `Renders kibibytes`() {
        #expect(1536.formatted(Byte.Size.Formatter(scale: iec)) == "1.5 KiB")
    }

    @Test
    func `Renders mebibytes`() {
        #expect((3 * 1024 * 1024).formatted(Byte.Size.Formatter(scale: iec)) == "3.0 MiB")
    }

    @Test
    func `Exactly one kibibyte`() {
        #expect(1024.formatted(Byte.Size.Formatter(scale: iec)) == "1.0 KiB")
    }

    @Test
    func `Zero renders in the base unit`() {
        #expect(0.formatted(Byte.Size.Formatter(scale: iec)) == "0.0 B")
    }
}

// MARK: - Byte.Size.Formatter — Precision

@Suite
struct `Byte.Size.Formatter - Precision` {

    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}

    @Test
    func `Precision zero drops the fraction`() {
        #expect(1536.formatted(Byte.Size.Formatter(scale: iec, precision: 0)) == "1 KiB")
    }

    @Test
    func `Precision two pads fractional digits`() {
        #expect(1536.formatted(Byte.Size.Formatter(scale: iec, precision: 2)) == "1.50 KiB")
    }

    @Test
    func `Fractional digits truncate toward zero`() {
        // 1900 / 1024 = 1.85546875 → truncated to one digit is "1.8".
        #expect(1900.formatted(Byte.Size.Formatter(scale: iec, precision: 1)) == "1.8 KiB")
    }
}

// MARK: - Byte.Size.Formatter — Separator

@Suite
struct `Byte.Size.Formatter - Separator` {

    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}

    @Test
    func `Empty separator joins mantissa and unit`() {
        #expect(1536.formatted(Byte.Size.Formatter(scale: iec, separator: "")) == "1.5KiB")
    }
}

// MARK: - Byte.Size.Formatter — Sign and integer types

@Suite
struct `Byte.Size.Formatter - Sign and types` {

    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}

    @Test
    func `Negative counts render with a leading minus`() {
        #expect((-1536).formatted(Byte.Size.Formatter(scale: iec)) == "-1.5 KiB")
    }

    @Test
    func `Works for an unsigned count type`() {
        let count: UInt = 1536
        #expect(count.formatted(Byte.Size.Formatter(scale: iec)) == "1.5 KiB")
    }

    @Test
    func `Values above the top tier stay on the top tier`() {
        // Only a "k" tier reaches; 5_000_000 has no higher rung here.
        let kOnly = Byte.Size.Scale(
            base: 1000,
            unitSymbol: "B",
            tiers: [.init(exponent: 1, symbol: "k")]
        )
        #expect(5_000_000.formatted(Byte.Size.Formatter(scale: kOnly)) == "5000.0 kB")
    }
}

// MARK: - Byte.Size.Formatter — Formatter.Protocol conformance

@Suite
struct `Byte.Size.Formatter - Formatter.Protocol conformance` {

    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}

    @Test
    func `format() method renders directly`() {
        let format = Byte.Size.Formatter<Int>(scale: iec)
        #expect(format.format(1536) == "1.5 KiB")
    }

    @Test
    func `Works via the generic formatted overload`() {
        #expect(1536.formatted(Byte.Size.Formatter<Int>(scale: iec)) == "1.5 KiB")
    }
}
