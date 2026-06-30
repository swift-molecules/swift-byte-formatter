import Testing

@testable import Byte_Formatter_Primitives

// MARK: - Byte.Formatter — Hexadecimal

@Suite
struct `Byte.Formatter - Hexadecimal` {

    @Test
    func `All-ones byte renders ff`() {
        let byte: Byte = 0xFF
        #expect(byte.formatted(.hexadecimal) == "ff")
    }

    @Test
    func `Single nibble pads to two glyphs`() {
        #expect(Byte(0x0A).formatted(.hexadecimal) == "0a")
    }

    @Test
    func `Zero renders 00`() {
        #expect(Byte(0).formatted(.hexadecimal) == "00")
    }

    @Test
    func `Mixed byte renders both nibbles`() {
        #expect(Byte(0xAB).formatted(.hexadecimal) == "ab")
    }

    @Test
    func `Hex output is always two glyphs`() {
        for raw in UInt8.min...UInt8.max {
            #expect(Byte(raw).formatted(.hexadecimal).count == 2)
        }
    }
}

// MARK: - Byte.Formatter — Other radixes

@Suite
struct `Byte.Formatter - Other radixes` {

    @Test
    func `Decimal renders three fixed-width glyphs`() {
        #expect(Byte(255).formatted(Byte.Formatter(radix: .decimal)) == "255")
        #expect(Byte(10).formatted(Byte.Formatter(radix: .decimal)) == "010")
        #expect(Byte(0).formatted(Byte.Formatter(radix: .decimal)) == "000")
    }

    @Test
    func `Binary renders eight fixed-width glyphs`() {
        #expect(Byte(0b1010_0000).formatted(Byte.Formatter(radix: .binary)) == "10100000")
        #expect(Byte(1).formatted(Byte.Formatter(radix: .binary)) == "00000001")
    }
}

// MARK: - Byte.Formatter — Formatter.Protocol conformance

@Suite
struct `Byte.Formatter - Formatter.Protocol conformance` {

    @Test
    func `format() method renders directly`() {
        #expect(Byte.Formatter.hexadecimal.format(Byte(0xFF)) == "ff")
    }

    @Test
    func `Works via the generic formatted overload`() {
        let byte: Byte = 0x0A
        #expect(byte.formatted(Byte.Formatter.hexadecimal) == "0a")
    }
}
