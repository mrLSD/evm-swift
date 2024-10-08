/// Represents the state of gas during execution.
public struct Gas {
    /// The initial gas limit. This is constant throughout execution.
    let limit: UInt64
    /// The remaining gas.
    private(set) var remaining: UInt64
    /// Refunded gas. This is used only at the end of execution.
    private(set) var refunded: Int64
    /// Returns the total amount of gas spent.
    @inline(__always)
    var spent: UInt64 { self.limit - self.remaining }

    /// Creates a new `Gas` struct with the given gas limit.
    init(limit: UInt64) {
        self.limit = limit
        self.remaining = limit
        self.refunded = 0
    }

    /// Creates a new `Gas` struct with the given gas limit, but without any gas remaining.
    init(withoutRemain limit: UInt64) {
        self.limit = limit
        self.remaining = 0
        self.refunded = 0
    }

    /// Records a refund gas value.
    ///
    /// `refund` can be negative but `self.refunded` should always be positive
    /// at the end of transact.
    @inline(__always)
    mutating func recordRefund(refund: Int64) {
        self.refunded += refund
    }

    /// Sets the final refund based on the provided `isLondon` flag - London hard fork flag.
    ///
    /// This method adjusts the `refunded` property by taking the minimum of the current refunded amount
    /// and the spent amount divided by a quotient that depends on whether the London rules apply.
    ///
    /// - Parameter isLondon: A Boolean indicating whether London hard fork.
    mutating func setFinalRefund(isLondon: Bool) {
        let maxRefundQuotient: UInt64 = isLondon ? 5 : 2
        // Check UInt64 bounds to avoid overflow
        self.refunded = self.refunded < 0 ? 0 : Int64(min(UInt64(self.refunded), self.spent / maxRefundQuotient))
    }

    /// Records the gas cost by subtracting the given cost from the remaining gas.
    /// Returns `Overflow` status for the gas limit is exceeded.
    ///
    /// - Parameter cost: The cost to subtract.
    /// - Returns: `true` if the subtraction was successful without underflow, `false` otherwise.
    @inline(__always)
    mutating func recordCost(cost: UInt64) -> Bool {
        let (newRemaining, overflow) = self.remaining.subtractingReportingOverflow(cost)
        let success = !overflow
        if success {
            self.remaining = newRemaining
        }
        return success
    }
}

/// Gas constants for record gas cost calculation
enum GasConstant {
    static let VERYLOW: UInt64 = 3
    static let LOW: UInt64 = 3
}
