public import Byte
public import Formatter

extension Byte {

    @inlinable
    public func formatted(_ format: Byte.Formatter) -> String {
        format.format(self)
    }

    @inlinable
    public func formatted<F>(_ format: F) -> F.Output
    where F: Formatter.Formatter.`Protocol`, F.Input == Self, F.Failure == Never {
        format.format(self)
    }
}
