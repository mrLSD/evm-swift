public struct U512: BigUInt {
    private let bytes: [UInt64]

    public static let numberBytes: UInt8 = 64
    public static let MAX: Self = getMax
    public static let ZERO: Self = getZero

    public var BYTES: [UInt64] { self.bytes }

    public init(from value: [UInt64]) {
        precondition(value.count == Self.numberBase, "U512 must be initialized with \(Self.numberBase) UInt64 values.")
        self.bytes = value
    }

    public init(from value: U256) {
        self.bytes = [value.BYTES[0], value.BYTES[1], value.BYTES[2], value.BYTES[3], 0, 0, 0, 0]
    }
}
