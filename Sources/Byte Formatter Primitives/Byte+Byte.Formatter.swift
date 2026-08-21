public import Byte_Primitives
public import Formatter_Primitives

extension Byte {

    @inlinable
    public func formatted(_ format: Byte.Formatter) -> String {
        format.format(self)
    }

    @inlinable
    public func formatted<F>(_ format: F) -> F.Output
    where F: Formatter_Primitives.Formatter.`Protocol`, F.Input == Self, F.Failure == Never {
        format.format(self)
    }
}
