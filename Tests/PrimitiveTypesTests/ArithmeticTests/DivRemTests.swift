import Nimble
import Quick

@testable import PrimitiveTypes

final class ArithmeticDivRemSpec: QuickSpec {
    override class func spec() {
        describe("divRem operation") {
            context("common division cases") {
                /*
                 it("dividing by one") {
                     let a = U256(from: [1, 2, 3, 4])
                     let b = U256(from: [1, 0, 0, 0])
                     let (quotient, remainder) = a.divRem(divisor: b)

                     expect(quotient.BYTES).to(equal([1, 2, 3, 4]))
                     expect(remainder.BYTES).to(equal([0, 0, 0, 0]))
                 }

                                 it("dividing max value by one") {
                                     let a = U256(from: [UInt64.max, UInt64.max, UInt64.max, UInt64.max])
                                     let b = U256(from: [1, 0, 0, 0])
                                     let (quotient, remainder) = a.divRem(divisor: b)

                                     expect(quotient.BYTES).to(equal([UInt64.max, UInt64.max, UInt64.max, UInt64.max]))
                                     expect(remainder.BYTES).to(equal([0, 0, 0, 0]))
                                 }

                                 it("dividing by max value") {
                                     let a = U256(from: [UInt64.max, UInt64.max, UInt64.max, UInt64.max])
                                     let b = U256(from: [UInt64.max, 0, 0, 0])
                                     let (quotient, remainder) = a.divRem(divisor: b)

                                     expect(quotient.BYTES).to(equal([1, 1, 1, 1]))
                                     expect(remainder.BYTES).to(equal([0, 0, 0, 0]))
                                 }

                                 it("partial remainder when dividing") {
                                     let a = U256(from: [1, 2, 3, 4])
                                     let b = U256(from: [2, 0, 0, 0])
                                     let (quotient, remainder) = a.divRem(divisor: b)

                                     expect(quotient.BYTES).to(equal([0, 1, 1, 2]))
                                     expect(remainder.BYTES).to(equal([1, 0, 0, 0]))
                                 }

                                 it("large number division") {
                                     let a = U256(from: [100, 200, 300, 400])
                                     let b = U256(from: [5, 0, 0, 0])
                                     let (quotient, remainder) = a.divRem(divisor: b)

                                     expect(quotient.BYTES).to(equal([20, 40, 60, 80]))
                                     expect(remainder.BYTES).to(equal([0, 0, 0, 0]))
                                 }
                             }

                             context("edge cases") {
                                 it("dividing by zero") {
                                     let a = U256(from: [1, 2, 3, 4])
                                     let b = U256(from: [0, 0, 0, 0])
                                     expect {
                                         _ = a.divRem(divisor: b)
                                     }.to(throwError())
                                 }

                                 it("dividing zero by any number") {
                                     let a = U256(from: [0, 0, 0, 0])
                                     let b = U256(from: [1, 0, 0, 0])
                                     let (quotient, remainder) = a.divRem(divisor: b)

                                     expect(quotient.BYTES).to(equal([0, 0, 0, 0]))
                                     expect(remainder.BYTES).to(equal([0, 0, 0, 0]))
                                 }

                                 it("dividing by a larger number") {
                                     let a = U256(from: [1, 0, 0, 0])
                                     let b = U256(from: [2, 0, 0, 0])
                                     let (quotient, remainder) = a.divRem(divisor: b)

                                     expect(quotient.BYTES).to(equal([0, 0, 0, 0]))
                                     expect(remainder.BYTES).to(equal([1, 0, 0, 0]))
                                 }

                                 it("dividing max value by half of max") {
                                     let a = U256(from: [UInt64.max, 0, 0, 0])
                                     let b = U256(from: [UInt64.max / 2, 0, 0, 0])
                                     let (quotient, remainder) = a.divRem(divisor: b)

                                     expect(quotient.BYTES).to(equal([2, 0, 0, 0]))
                                     expect(remainder.BYTES).to(equal([0, 0, 0, 0]))
                                 }

                                 it("partial overflow during division") {
                                     let a = U256(from: [UInt64.max, 1, 0, 0])
                                     let b = U256(from: [2, 0, 0, 0])
                                     let (quotient, remainder) = a.divRem(divisor: b)

                                     expect(quotient.BYTES).to(equal([UInt64.max / 2, 0, 0, 0]))
                                     expect(remainder.BYTES).to(equal([1, 0, 0, 0]))
                                 }
                  */
            }
        }
    }
}