# Byte Formatter

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

Text rendering of byte data for Swift — human-readable byte **sizes** (`"1.5 KiB"`) through a dependency-inversion seam, and **hexadecimal** rendering of a single byte (`"ff"`). Foundation-free, with zero platform dependencies.

---

## Quick Start

### Byte sizes

`Byte.Size.Formatter` renders a count of bytes as a human-readable storage magnitude. It is a generic **dependency-inversion seam**: the prefix ladder it renders against — the SI (base-1000) or IEC (base-1024) one — is *injected* by the caller as a `Byte.Size.Scale`. This package has no knowledge of SI, IEC, or the ISO/IEC 80000 prefixes; it is pure tiers.

```swift
import Byte_Formatter

let iec = Byte.Size.Scale(
    base: 1024,
    unitSymbol: "B",
    tiers: [
        .init(exponent: 1, symbol: "Ki"),
        .init(exponent: 2, symbol: "Mi"),
        .init(exponent: 3, symbol: "Gi"),
    ]
)

1536.formatted(Byte.Size.Formatter(scale: iec))                    // "1.5 KiB"
(3 * 1024 * 1024).formatted(Byte.Size.Formatter(scale: iec))       // "3.0 MiB"
512.formatted(Byte.Size.Formatter(scale: iec))                     // "512.0 B"
1536.formatted(Byte.Size.Formatter(scale: iec, precision: 2))      // "1.50 KiB"
```

The largest tier whose `base^exponent` does not exceed the count is selected, then the mantissa is rendered with `precision` fractional digits and the tier's unit. The mantissa is produced by **integer math only** — no floating point, no `Foundation`, no `String(format:)`. Tier selection is overflow-safe: factors for tiers above the chosen one (which overflow fixed-width integers) are never computed.

A `Byte.Size.Scale` carries a `base`, a `unitSymbol` (for example `"B"`), and an ascending ladder of `(exponent, symbol)` tiers — the *prefix* per tier (`"Ki"`), rendered ahead of the unit symbol to spell `"KiB"`. Storing the exponent rather than the expanded factor is what keeps tebibytes and beyond from overflowing.

> The leading-dot call site `count.formatted(.bytes(.binary))` is supplied by the SI/IEC binding (`swift-iec-80000-13`), which injects the concrete prefix ladders this package's seam ranges over.

### Byte hex

`Byte.Formatter` renders a single `Byte` as fixed-width text in a `Radix`, hexadecimal by default. The digit alphabet comes from `swift-radix`.

```swift
let byte: Byte = 0xFF
byte.formatted(.hexadecimal)                          // "ff"
Byte(0x0A).formatted(.hexadecimal)                    // "0a"
Byte(255).formatted(Byte.Formatter(radix: .decimal))  // "255"
```

Output is fixed-width: two glyphs for hexadecimal, three for decimal, eight for binary, leading zeros included.

Both formatters conform to the same `Formatter.Protocol` as every other style in the ecosystem, so they are reached through `.formatted(_:)` and compose with the generic entry point.

---

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/swift-molecules/swift-byte-formatter.git", branch: "main")
]
```

```swift
.target(
    name: "App",
    dependencies: [
        .product(name: "Byte Formatter", package: "swift-byte-formatter"),
    ]
)
```

Requires Swift 6.4 and macOS 27 / iOS 27 / tvOS 27 / watchOS 27 / visionOS 27 (or the matching Linux / Windows toolchain).

---

## Architecture

`import Byte_Formatter` surfaces the whole package — `Byte.Formatter` directly, and `Byte.Size.Formatter` re-exported from the lean size module. A size-only consumer that wants to stay free of the radix engine imports `Byte Size Formatter` directly instead.

| Product | Target | When to import |
|---------|--------|----------------|
| `Byte Formatter` | `Sources/Byte Formatter/` | The default. `Byte.Formatter` — fixed-width radix (hex) rendering of a `Byte` — plus its `.formatted(_:)` entry point; re-exports the byte-size module below. |
| `Byte Size Formatter` | `Sources/Byte Size Formatter/` | `Byte.Size.Scale` + `Byte.Size.Formatter` — the byte-size dependency-inversion seam, plus the `.formatted(_:)` entry point on `BinaryInteger`. Depends only on the atom-owned `Byte` and `Formatter` surfaces — **no radix engine**. Import this directly when you need byte sizes without pulling in radix. |
| `Byte Formatter Test Support` | `Tests/Support/` | Re-exports the package for test consumers. |

Built on the atom-owned `Byte` (for `Byte`), `Radix` (for the digit alphabet), and `Formatter` (for the formatting capability) surfaces. The size seam deliberately does **not** depend on the radix engine. Foundation-free.

---

## Platform Support

| Platform | Status |
|----------|--------|
| macOS 27 | Full support |
| Linux | Full support |
| Windows | Full support |
| iOS / tvOS / watchOS / visionOS | Supported |

---

## Community

<!-- BEGIN: discussion -->
<!-- Discussion thread created at publication. -->
<!-- END: discussion -->

## License

Apache 2.0. See [LICENSE.md](LICENSE.md).
