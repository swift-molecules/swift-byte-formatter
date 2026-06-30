# ``Byte_Formatter_Primitives``

@Metadata {
    @DisplayName("Byte Formatter Primitives")
    @TitleHeading("Swift Primitives")
}

Text rendering of byte data: human-readable byte *sizes* (`"1.5 KiB"`) via an
injected prefix ladder, and *hex* rendering of a single byte (`"ff"`).

## Overview

This package carries the **dependency-inversion seam** for byte-size
formatting. The generic algorithm (``Byte/Size/Formatter``) and the inversion point
it ranges over (``Byte/Size/Scale``) live here at Layer 1; the concrete SI
(base-1000) and IEC (base-1024) prefix ladders are injected from a higher layer.
This package has no knowledge of SI, IEC, or the ISO/IEC 80000 prefixes.

A second, smaller concern renders a single ``Byte`` as fixed-width radix text
(``Byte/Formatter``), taking its digit alphabet from `swift-radix-primitives`.

## Topics

### Formatting Byte Sizes

- ``Byte/Size``
- ``Byte/Size/Scale``
- ``Byte/Size/Formatter``

### Formatting a Byte as Hex

- ``Byte/Formatter``
