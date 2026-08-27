public import Formatter

extension BinaryInteger {

    @inlinable
    public func formatted(_ format: Byte.Size.Formatter<Self>) -> String {
        format.format(self)
    }

    @inlinable
    public func formatted<F>(_ format: F) -> F.Output
    where F: Formatter::Formatter.`Protocol`, F.Input == Self, F.Failure == Never {
        format.format(self)
    }
}
