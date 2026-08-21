public import Formatter_Primitives

extension BinaryInteger {

    @inlinable
    public func formatted(_ format: Byte.Size.Formatter<Self>) -> String {
        format.format(self)
    }

    @inlinable
    public func formatted<F>(_ format: F) -> F.Output
    where F: Formatter_Primitives.Formatter.`Protocol`, F.Input == Self, F.Failure == Never {
        format.format(self)
    }
}
