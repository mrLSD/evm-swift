public extension BigUInt {
    /// Performs an overflow addition operation with the given value.
    ///
    /// - Parameter value: The value to be added.
    ///
    /// - Returns: A tuple containing the result of the addition and a boolean value indicating whether an overflow occurred.
    func overflowAdd(_ value: Self) -> (Self, Bool) {
        var result = [UInt64](repeating: 0, count: Int(Self.numberBase))
        var carry = false

        for i in 0 ..< Int(Self.numberBase) {
            let sum = self.BYTES[i].addingReportingOverflow(value.BYTES[i])
            let total = sum.partialValue.addingReportingOverflow(carry ? 1 : 0)

            result[i] = total.partialValue
            carry = sum.overflow || total.overflow
        }
        let isOverflow = carry
        return (Self(from: result), isOverflow)
    }

    /// Performs an overflow subtraction operation on the current value with the given value.
    ///
    /// - Parameter value: The value to subtract from the current value.
    ///
    /// - Returns: A tuple containing the result of the subtraction operation and a boolean value indicating whether an overflow occurred.
    func overflowSub(_ value: Self) -> (Self, Bool) {
        var result = [UInt64](repeating: 0, count: Int(Self.numberBase))
        var borrow = false

        for i in 0 ..< Int(Self.numberBase) {
            let sub = self.BYTES[i].subtractingReportingOverflow(value.BYTES[i])
            let total = sub.partialValue.subtractingReportingOverflow(borrow ? 1 : 0)
            result[i] = total.partialValue
            borrow = sub.overflow || total.overflow
        }
        let isOverflow = borrow
        return (Self(from: result), isOverflow)
    }

    /// Performs an overflow multiplication operation with the given value.
    ///
    /// Algorithm base on `mac` (multiply-accumulate) operation. It's optimised to avoid
    /// redundant operations with matrix. In common cases multiplication `2*Width`. For
    /// 256-bit in common cases result will be 512-bit - `high` and `low` part. `Low` contains
    /// result itself, `high` contains overflowed number. We're oprimised algorithm to return only `Width`,
    /// itself, to avoid redundant calculations, and just calculating `overflow` flag.
    ///
    /// - Parameter value: The value to be multiplying.
    ///
    /// - Returns: A tuple containing the result of the operation and a boolean value indicating whether an overflow occurred.
    @inline(__always)
    func overflowMul(_ value: Self) -> (Self, Bool) {
        var result = [UInt64](repeating: 0, count: Int(2 * Self.numberBase))

        // Matrix multiplication
        for i in 0 ..< Int(Self.numberBase) {
            var carry: UInt64 = 0
            for j in 0 ..< Int(Self.numberBase) {
                carry = Self.mac(&result[i + j], self.BYTES[i], value.BYTES[j], carry)
            }
            result[i + Int(Self.numberBase)] = carry
        }
        let isOverflow = result[Int(Self.numberBase) ..< 2 * Int(Self.numberBase)].contains { $0 != 0 }
        let lowResult = Array(result[0 ..< Int(Self.numberBase)])
        return (Self(from: lowResult), isOverflow)
    }

    /// Performs multiplication operation with the given value without overflow check.
    ///
    /// Algorithm base on `mac` (multiply-accumulate) operation. It's optimised to avoid
    /// redundant operations with matrix. In common cases multiplication `2*Width`. For
    /// 256-bit in common cases result will be 512-bit - `high` and `low` part. `Low` contains
    /// result itself, `high` contains overflowed number. We're optimised algorithm to return only `Width`,
    /// itself, to avoid redundant calculations, but for that we can't correclty calculate overflow status (for that
    /// we should perform full multiplication).
    ///
    /// - Parameter value: The value to be multiplying.
    ///
    /// - Returns: A tuple containing the result of the operation and a boolean value indicating whether an overflow occurred.
    @inline(__always)
    func mul(_ value: Self) -> Self {
        var result = [UInt64](repeating: 0, count: Int(Self.numberBase))

        // Matrix multiplication
        for i in 0 ..< Int(Self.numberBase) {
            var carry: UInt64 = 0
            // Restrict multiplication operations to `Self.numberBase` and carry overflow status.
            for j in 0 ... (Int(Self.numberBase) - 1 - i) {
                carry = Self.mac(&result[i + j], self.BYTES[i], value.BYTES[j], carry)
            }
        }
        return Self(from: result)
    }

    ///  Calculates the multiply-accumulate operation.
    ///
    ///  - Parameters:
    ///     - lhs: The left-hand side value to be updated with the result.
    ///     - a: The first operand of the multiplication.
    ///     - b: The second operand of the multiplication.
    ///     - carry: The carry value to be added.
    ///
    ///  - Returns: The result of the multiply-accumulate operation.
    @inline(__always)
    internal static func mac(_ lhs: inout UInt64, _ a: UInt64, _ b: UInt64, _ carry: UInt64) -> UInt64 {
        let (productHigh, productLow) = a.multipliedFullWidth(by: b)
        let (sumLow1, carry1) = productLow.addingReportingOverflow(carry)
        let (sumLow2, carry2) = sumLow1.addingReportingOverflow(lhs)
        lhs = sumLow2
        return productHigh &+ (carry1 ? 1 : 0) &+ (carry2 ? 1 : 0)
    }

    @inline(__always)
    func shiftLeft(_ shift: Int) -> Self {
        var result = [UInt64](repeating: 0, count: Int(Self.numberBase))
        let wordShift = shift / 64
        let bitShift = shift % 64

        // Shift
        for i in wordShift ..< Int(Self.numberBase) {
            result[i] = self.BYTES[i - wordShift] << bitShift
        }

        // Carry
        if bitShift > 0 {
            for i in wordShift + 1 ..< Int(Self.numberBase) {
                result[i] += self.BYTES[i - 1 - wordShift] >> (64 - bitShift)
            }
        }
        return Self(from: result)
    }

    @inline(__always)
    func shiftRight(_ shift: Int) -> Self {
        var result = [UInt64](repeating: 0, count: Int(Self.numberBase))
        let wordShift = shift / 64
        let bitShift = shift % 64

        // Shift
        for i in wordShift ..< Int(Self.numberBase) {
            result[i - wordShift] = self.BYTES[i] >> bitShift
        }

        // Carry
        if bitShift > 0 {
            for i in wordShift + 1 ..< Int(Self.numberBase) {
                result[i - wordShift - 1] += self.BYTES[i] << (64 - bitShift)
            }
        }
        return Self(from: result)
    }

    /// Adds two values of the same type together and returns the result.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side value to be added.
    ///   - rhs: The right-hand side value to be added.
    ///
    /// - Returns: The sum of the two values.
    static func + (lhs: Self, rhs: Self) -> Self {
        let (result, _) = lhs.overflowAdd(rhs)
        return result
    }

    /// Subtracts two values of the same type.
    ///
    /// - Parameters:
    ///   - lhs: The value to subtract from.
    ///   - rhs: The value to subtract.
    ///
    /// - Returns: The result of subtracting `rhs` from `lhs`.
    static func - (lhs: Self, rhs: Self) -> Self {
        let (result, _) = lhs.overflowSub(rhs)
        return result
    }

    static func << (lhs: Self, shift: Int) -> Self {
        lhs.shiftLeft(shift)
    }

    static func >> (lhs: Self, shift: Int) -> Self {
        lhs.shiftRight(shift)
    }
}
