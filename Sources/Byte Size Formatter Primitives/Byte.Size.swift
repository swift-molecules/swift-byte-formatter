// Byte.Size.swift
// Namespace for byte-size (storage-magnitude) formatting.

public import Byte_Primitive

extension Byte {
    /// Namespace for byte-*size* formatting — rendering a count of bytes as a
    /// human-readable storage magnitude such as `"1.5 KiB"` or `"1.5 kB"`.
    ///
    /// `Byte.Size` is the home of the **dependency-inversion seam** for byte-size
    /// formatting. The generic rendering algorithm (``Byte/Size/Formatter``) and the
    /// inversion point it ranges over (``Byte/Size/Scale``) live here at Layer 1;
    /// the concrete SI (base-1000) and IEC (base-1024) prefix ladders are
    /// *injected* from a higher layer. This package therefore carries no
    /// knowledge of SI, IEC, or the ISO/IEC 80000 prefixes — only the pure
    /// tier-ladder mechanism.
    ///
    /// ```swift
    /// // A scale is supplied by the caller (an L2 binding, or ad hoc):
    /// let decimal = Byte.Size.Scale(
    ///     base: 1000,
    ///     unitSymbol: "B",
    ///     tiers: [.init(exponent: 1, symbol: "k"), .init(exponent: 2, symbol: "M")]
    /// )
    ///
    /// 1500.formatted(Byte.Size.Formatter(scale: decimal))   // "1.5 kB"
    /// ```
    public enum Size {}
}
