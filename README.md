# Byte Formatter Primitives

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

Text rendering of byte data for Swift — human-readable byte **sizes** (`"1.5 KiB"`) through a dependency-inversion seam, and **hexadecimal** rendering of a single byte (`"ff"`). Foundation-free, with zero platform dependencies.

---

## Quick Start

### Byte sizes

`Byte.Size.Format` renders a count of bytes as a human-readable storage magnitude. It is the generic half of a **dependency-inversion seam**: the algorithm lives here at Layer 1, but the prefix ladder it renders against — the SI (base-1000) or IEC (base-1024) one — is *injected* by the caller as a `Byte.Size.Scale`. This package has no knowledge of SI, IEC, or the ISO/IEC 80000 prefixes; it is pure tiers.

```swift
import Byte_Formatter_Primitives

let iec = Byte.Size.Scale(
    base: 1024,
    unitSymbol: "B",
    tiers: [
        .init(exponent: 1, symbol: "Ki"),
        .init(exponent: 2, symbol: "Mi"),
        .init(exponent: 3, symbol: "Gi"),
    ]
)

1536.formatted(Byte.Size.Format(scale: iec))                    // "1.5 KiB"
(3 * 1024 * 1024).formatted(Byte.Size.Format(scale: iec))       // "3.0 MiB"
512.formatted(Byte.Size.Format(scale: iec))                     // "512.0 B"
1536.formatted(Byte.Size.Format(scale: iec, precision: 2))      // "1.50 KiB"
```

The largest tier whose `base^exponent` does not exceed the count is selected, then the mantissa is rendered with `precision` fractional digits and the tier's unit. The mantissa is produced by **integer math only** — no floating point, no `Foundation`, no `String(format:)`. Tier selection is overflow-safe: factors for tiers above the chosen one (which overflow fixed-width integers) are never computed.

A `Byte.Size.Scale` carries a `base`, a `unitSymbol` (for example `"B"`), and an ascending ladder of `(exponent, symbol)` tiers — the *prefix* per tier (`"Ki"`), rendered ahead of the unit symbol to spell `"KiB"`. Storing the exponent rather than the expanded factor is what keeps tebibytes and beyond from overflowing.

### Byte hex

`Byte.Format` renders a single `Byte` as fixed-width text in a `Radix`, hexadecimal by default. The digit alphabet comes from `swift-radix-primitives`.

```swift
let byte: Byte = 0xFF
byte.formatted(.hexadecimal)                       // "ff"
Byte(0x0A).formatted(.hexadecimal)                 // "0a"
Byte(255).formatted(Byte.Format(radix: .decimal))  // "255"
```

Output is fixed-width: two glyphs for hexadecimal, three for decimal, eight for binary, leading zeros included.

Both formatters conform to the same `Formatter.Protocol` as every other style in the ecosystem, so they are reached through `.formatted(_:)` and compose with the generic entry point.

---

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/swift-primitives/swift-byte-formatter-primitives.git", branch: "main")
]
```

```swift
.target(
    name: "App",
    dependencies: [
        .product(name: "Byte Formatter Primitives", package: "swift-byte-formatter-primitives"),
    ]
)
```

Requires Swift 6.3.1 and macOS 26 / iOS 26 / tvOS 26 / watchOS 26 / visionOS 26 (or the matching Linux / Windows toolchain).

---

## Architecture

The umbrella `Byte Formatter Primitives` re-exports both modules below; import a sub-target directly when you want only one concern.

| Product | Target | Purpose |
|---------|--------|---------|
| `Byte Formatter Primitives` | `Sources/Byte Formatter Primitives/` | Umbrella that re-exports the modules below. |
| `Byte Size Format Primitives` | `Sources/Byte Size Format Primitives/` | `Byte.Size.Scale` + `Byte.Size.Format` — the byte-size dependency-inversion seam, plus the `.formatted(_:)` entry point on `BinaryInteger`. Depends only on `Byte` and `Formatter.Protocol` — no radix engine. |
| `Byte Format Primitives` | `Sources/Byte Format Primitives/` | `Byte.Format` — fixed-width radix (hex) rendering of a `Byte`, plus its `.formatted(_:)` entry point. |
| `Byte Formatter Primitives Test Support` | `Tests/Support/` | Re-exports the umbrella for test consumers. |

Built on `Byte Primitive` (for `Byte`), `Radix Primitive` (for the hex digit alphabet), and `Formatter Primitives` (for the `Formatter.Protocol` capability). The size seam deliberately does **not** depend on the radix engine. Foundation-free.

---

## Platform Support

| Platform | Status |
|----------|--------|
| macOS 26 | Full support |
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
