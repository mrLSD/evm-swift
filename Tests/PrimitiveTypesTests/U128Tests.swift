import Nimble
@testable import PrimitiveTypes
import Quick

final class U128Spec: QuickSpec {
    override class func spec() {
        describe("U128 type") {
            context("when init data wrong panics with message") {
                func expectFailInit(array arr: [UInt64]) {
                    expect(captureStandardError {
                        expect {
                            _ = U128(from: arr)
                        }.to(throwAssertion())
                    }).to(contain("must be initialized with 2 UInt64 values"))
                }

                context("when number of bytes") {
                    it("is Empty") {
                        expectFailInit(array: [])
                    }
                    it("is 1") {
                        expectFailInit(array: [0])
                    }
                    it("is 3") {
                        expectFailInit(array: [0, 0, 0])
                    }
                    it("from Little Endian 17 bytes") {
                        expect(captureStandardError {
                            expect {
                                _ = U128.fromLittleEndian(from: [UInt8](repeating: 0, count: 17))
                            }.to(throwAssertion())
                        }).to(contain("must be initialized with not more than 16 bytes"))
                    }
                    it("from Big Endian 17 bytes") {
                        expect(captureStandardError {
                            expect {
                                _ = U128.fromBigEndian(from: [UInt8](repeating: 0, count: 17))
                            }.to(throwAssertion())
                        }).to(contain("must be initialized with not more than 16 bytes"))
                    }
                }

                context("wrong String for conversion") {
                    it("too big String") {
                        expect(captureStandardError {
                            expect {
                                _ = U128.fromString(hex: String(repeating: "A", count: 33))
                            }.to(throwAssertion())
                        }).to(contain("Invalid hex string for 16 bytes"))
                    }
                    it("String length to compared to `mod 2`") {
                        expect(captureStandardError {
                            expect {
                                _ = U128.fromString(hex: String(repeating: "A", count: 1))
                            }.to(throwAssertion())
                        }).to(contain("Invalid hex string for `mod 2"))
                    }
                    it("String contains wrong character G") {
                        expect(captureStandardError {
                            expect {
                                _ = U128.fromString(hex: "0G")
                            }.to(throwAssertion())
                        }).to(contain("Invalid hex string byte character: 0G"))
                    }
                }
            }

            context("when convert from small numbers") {
                it("correct transformed from Little Endian number 0x01AC") {
                    expect(U128.fromLittleEndian(from: [0x1, 0xac])).to(equal(U128(from: [0xac01, 0])))
                }
                it("correct transformed from Big Endian number 0x01AC") {
                    expect(U128.fromBigEndian(from: [0x1, 0xac])).to(equal(U128(from: [0x01ac, 0])))
                }
            }

            context("when init as MAX value") {
                let val = U128.MAX
                it("correct bytes") {
                    expect(val.BYTES).to(equal([UInt64.max, UInt64.max]))
                }
                it("not Zero value") {
                    expect(val.isZero).to(beFalse())
                }
                it("not u64 MAX") {
                    expect(val).toNot(equal(U128(from: UInt64.max)))
                }
                it("correct transformed to String") {
                    expect("\(val)").to(equal("FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF"))
                }
                it("correct transformed from String") {
                    expect(U128.fromString(hex: "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF")).to(equal(val))
                }
                it("correct transformed to Little Endian array") {
                    expect(val.toLittleEndian).to(equal([UInt8](repeating: 0xff, count: 16)))
                }
                it("correct transformed to Bit Endian array") {
                    expect(val.toBigEndian).to(equal([UInt8](repeating: 0xff, count: 16)))
                }
                it("correct transformed from Little Endian") {
                    expect(U128.fromLittleEndian(from: val.toLittleEndian)).to(equal(val))
                }
                it("correct transformed from Big Endian") {
                    expect(U128.fromBigEndian(from: val.toBigEndian)).to(equal(val))
                }
            }

            context("when init as ZERO value") {
                let val = U128.ZERO
                it("correct bytes") {
                    expect(val.BYTES).to(equal([0, 0]))
                }
                it("not Zero value") {
                    expect(val.isZero).to(beTrue())
                }
                it("not u64 MAX") {
                    expect(val).toNot(equal(U128(from: UInt64.max)))
                }
                it("correct transformed to String") {
                    expect("\(val)").to(equal("00000000000000000000000000000000"))
                }
                it("correct transformed from String") {
                    expect(U128.fromString(hex: "00000000000000000000000000000000")).to(equal(val))
                }
                it("correct transformed to Little Endian array") {
                    expect(val.toLittleEndian).to(equal([UInt8](repeating: 0, count: 16)))
                }
                it("correct transformed to Bit Endian array") {
                    expect(val.toBigEndian).to(equal([UInt8](repeating: 0, count: 16)))
                }
                it("correct transformed from Little Endian") {
                    expect(U128.fromLittleEndian(from: val.toLittleEndian)).to(equal(val))
                }
                it("correct transformed from Big Endian") {
                    expect(U128.fromBigEndian(from: val.toBigEndian)).to(equal(val))
                }
            }

            context("when concrete U128 value") {
                it("from Big-Endian") {
                    let val = U128.fromBigEndian(from: [
                        0xf, 1, 2, 3, 0xc1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0xac, 2,
                    ])
                    expect(0x000000000000ac02).to(equal(val.BYTES[0]))
                    expect(0x0f010203c1000000).to(equal(val.BYTES[1]))
                }
                it("from Little-Endian") {
                    let val = U128.fromLittleEndian(from: [
                        0xf, 1, 2, 3, 0xc1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0xac, 2,
                    ])
                    expect(0x000000c10302010f).to(equal(val.BYTES[0]))
                    expect(0x02ac000000000000).to(equal(val.BYTES[1]))
                }

                it("getUInt") {
                    let val = U128.fromLittleEndian(from: [
                        0xf, 1, 2, 3, 0xc1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0xac, 2,
                    ])
                    expect(0x000000c10302010f).to(equal(val.getUInt))
                }
            }

            context("when testing normalize") {
                it("should correctly normalize divisor and dividend with shift > 0") {
                    let divisor = U128(from: [0x0000000000000001, 0x0000000000000000]) // 1 in lower word
                    let dividend = U128(from: [0x0000000000000002, 0x0000000000000000]) // 2 in lower word
                    let (normalizedDivisor, normalizedDividend, shift) = divisor.normalize(divisor: divisor, dividend: dividend)

                    expect(normalizedDivisor).to(equal(U128(from: [0x0000000000000000, 0x8000000000000000])))
                    expect(normalizedDividend).to(equal(U128(from: [0x0000000000000000, 0x0000000000000000])))
                    expect(shift).to(equal(127))
                }

                it("should correctly normalize when shift is 0") {
                    let divisor = U128(from: [0xffffffffffffffff, 0x0000000000000001]) // No leading zeros
                    let dividend = U128(from: [0xffffffffffffffff, 0x0000000000000002])
                    let (normalizedDivisor, normalizedDividend, shift) = divisor.normalize(divisor: divisor, dividend: dividend)

                    expect(normalizedDivisor).to(equal(U128(from: [0x8000000000000000, 0xffffffffffffffff])))
                    expect(normalizedDividend).to(equal(U128(from: [0x8000000000000000, 0x7fffffffffffffff])))
                    expect(shift).to(equal(63))
                }

                it("should correctly normalize with partial shift") {
                    let divisor = U128(from: [0x000000000000000f, 0x0000000000000000]) // 15 in lower word
                    let dividend = U128(from: [0x000000000000001f, 0x0000000000000000]) // 31 in lower word
                    let (normalizedDivisor, normalizedDividend, shift) = divisor.normalize(divisor: divisor, dividend: dividend)

                    expect(normalizedDivisor).to(equal(U128(from: [0x0000000000000000, 0xf000000000000000])))
                    expect(normalizedDividend).to(equal(U128(from: [0x0000000000000000, 0xf000000000000000])))
                    expect(shift).to(equal(124))
                }

                it("should correctly normalize with shift=1") {
                    let divisor = U128(from: [0x8000000000000000, 0x0000000000000000]) // 1 << 63 in lower word
                    let dividend = U128(from: [0x8000000000000000, 0x0000000000000000]) // 1 << 63 in lower word
                    let (normalizedDivisor, normalizedDividend, shift) = divisor.normalize(divisor: divisor, dividend: dividend)

                    expect(normalizedDivisor).to(equal(U128(from: [0x0000000000000000, 0x8000000000000000])))
                    expect(normalizedDividend).to(equal(U128(from: [0x0000000000000000, 0x8000000000000000])))
                    expect(shift).to(equal(64))
                }

                it("should correctly normalize with shift=63") {
                    let divisor = U128(from: [0x0000000000000001, 0x0000000000000000]) // 1 in lower word
                    let dividend = U128(from: [0x0000000000000001, 0x0000000000000000]) // 1 in lower word
                    let (normalizedDivisor, normalizedDividend, shift) = divisor.normalize(divisor: divisor, dividend: dividend)

                    expect(normalizedDivisor).to(equal(U128(from: [0x0000000000000000, 0x8000000000000000])))
                    expect(normalizedDividend).to(equal(U128(from: [0x0000000000000000, 0x8000000000000000])))
                    expect(shift).to(equal(127))
                }

                it("should correctly normalize with shift=1") {
                    let divisor = U128(from: [0x8000000000000000, 0x0000000000000000]) // 1 << 63 in lower word
                    let dividend = U128(from: [0x8000000000000000, 0x0000000000000000]) // 1 << 63 in lower word

                    let (normalizedDivisor, normalizedDividend, shift) = divisor.normalize(divisor: divisor, dividend: dividend)

                    expect(normalizedDivisor).to(equal(U128(from: [0x0000000000000000, 0x8000000000000000])))
                    expect(normalizedDividend).to(equal(U128(from: [0x0000000000000000, 0x8000000000000000])))
                    expect(shift).to(equal(64))
                }

                it("should correctly normalize with shift=0") {
                    let divisor = U128(from: [0xffffffffffffffff, 0xffffffffffffffff])
                    let dividend = U128(from: [0xffffffffffffffff, 0xffffffffffffffff])

                    let (normalizedDivisor, normalizedDividend, shift) = divisor.normalize(divisor: divisor, dividend: dividend)

                    expect(normalizedDivisor).to(equal(divisor))
                    expect(normalizedDividend).to(equal(dividend))
                    expect(shift).to(equal(0))
                }

                it("should correctly normalize with shift=16") {
                    let divisor = U128(from: [0x0000ffff00000000, 0x0000000000000000])
                    let dividend = U128(from: [0x0000ffff00000000, 0x0000000000000000])
                    let (normalizedDivisor, normalizedDividend, shift) = divisor.normalize(divisor: divisor, dividend: dividend)

                    expect(normalizedDivisor).to(equal(U128(from: [0x0000000000000000, 0xffff000000000000])))
                    expect(normalizedDividend).to(equal(U128(from: [0x0000000000000000, 0xffff000000000000])))
                    expect(shift).to(equal(80))
                }

                it("should correctly normalize when shift is 63") {
                    let divisor = U128(from: [0xffffffffffffffff, 0x0000000000000001]) // [lowWord=0xffffffffffffffff, highWord=0x0000000000000001]
                    let dividend = U128(from: [0xffffffffffffffff, 0x0000000000000002]) // [lowWord=0xffffffffffffffff, highWord=0x0000000000000002]
                    let (normalizedDivisor, normalizedDividend, shift) = divisor.normalize(divisor: divisor, dividend: dividend)

                    expect(normalizedDivisor).to(equal(U128(from: [0x8000000000000000, 0xffffffffffffffff])))
                    expect(normalizedDividend).to(equal(U128(from: [0x8000000000000000, 0x7fffffffffffffff])))
                    expect(shift).to(equal(63))
                }

                it("should correctly normalize with shift=16") {
                    let divisor = U128(from: [0x0000000000000000, 0x0000ffff00000000])
                    let dividend = U128(from: [0x0000000000000000, 0x0000ffff00000000])

                    let (normalizedDivisor, normalizedDividend, shift) = divisor.normalize(divisor: divisor, dividend: dividend)

                    expect(normalizedDivisor).to(equal(U128(from: [0x0000000000000000, 0xffff000000000000])))
                    expect(normalizedDividend).to(equal(U128(from: [0x0000000000000000, 0xffff000000000000])))
                    expect(shift).to(equal(16))
                }

                it("should correctly normalize when shift is 0") {
                    let divisor = U128(from: [0xffffffffffffffff, 0x8000000000000000]) // [lowWord=0xffffffffffffffff, highWord=0x8000000000000000]
                    let dividend = U128(from: [0xffffffffffffffff, 0x8000000000000000]) // [lowWord=0xffffffffffffffff, highWord=0x8000000000000000]
                    let (normalizedDivisor, normalizedDividend, shift) = divisor.normalize(divisor: divisor, dividend: dividend)

                    expect(normalizedDivisor).to(equal(divisor))
                    expect(normalizedDividend).to(equal(dividend))
                    expect(shift).to(equal(0))
                }

                it("should correctly normalize with shift=64") {
                    let divisor = U128(from: [0x0000000000000000, 0x0000000000000001]) // [lowWord=0x0000000000000000, highWord=0x0000000000000001]
                    let dividend = U128(from: [0x0000000000000000, 0x0000000000000001]) // [lowWord=0x0000000000000000, highWord=0x0000000000000001]

                    let (normalizedDivisor, normalizedDividend, shift) = divisor.normalize(divisor: divisor, dividend: dividend)

                    expect(normalizedDivisor).to(equal(U128(from: [0x0000000000000000, 0x8000000000000000])))
                    expect(normalizedDividend).to(equal(U128(from: [0x0000000000000000, 0x8000000000000000])))
                    expect(shift).to(equal(63))
                }
            }

            context("when testing denormalize") {
                it("should correctly denormalize remainder with shift > 0") {
                    let remainder = U128(from: [0x0000000000000002, 0x0000000000000001]) // [2,1]
                    let shift = 64
                    let denormalized = remainder.denormalize(remainder: remainder, shift: shift)

                    expect(denormalized).to(equal(U128(from: [0x0000000000000001, 0x0000000000000000])))
                }

                it("should correctly denormalize when shift is 0") {
                    let remainder = U128(from: [0x123456789abcdef0, 0x0fedcba987654321])
                    let shift = 0
                    let denormalized = remainder.denormalize(remainder: remainder, shift: shift)

                    expect(denormalized).to(equal(remainder))
                }

                it("should correctly denormalize with partial shift") {
                    let remainder = U128(from: [0xf000000000000000, 0x0000000000000001]) // [0xF000...,1]
                    let shift = 4
                    let denormalized = remainder.denormalize(remainder: remainder, shift: shift)

                    expect(denormalized).to(equal(U128(from: [0x1f00000000000000, 0x0000000000000000])))
                }

                it("should correctly denormalize remainder with shift=1") {
                    let remainder = U128(from: [0x8000000000000000, 0x0000000000000000]) // [0x8000000000000000, 0]
                    let shift = 1

                    let denormalized = remainder.denormalize(remainder: remainder, shift: shift)

                    expect(denormalized).to(equal(U128(from: [0x4000000000000000, 0x0000000000000000])))
                }

                it("should correctly denormalize remainder with shift=63") {
                    let remainder = U128(from: [0x0000000000000001, 0x0000000000000000]) // [1, 0]
                    let shift = 63
                    let denormalized = remainder.denormalize(remainder: remainder, shift: shift)

                    expect(denormalized).to(equal(U128(from: [0x0000000000000000, 0x0000000000000000])))
                }

                it("should correctly denormalize with shift=32") {
                    let remainder = U128(from: [0x0000000100000000, 0x0000000000000001]) // [0x0000000100000000, 0x0000000000000001]
                    let shift = 32
                    let denormalized = remainder.denormalize(remainder: remainder, shift: shift)

                    expect(denormalized).to(equal(U128(from: [0x0000000100000001, 0x0000000000000000])))
                }

                it("should correctly denormalize with shift=16") {
                    let remainder = U128(from: [0x0001000000000000, 0x0000000000000001]) // [0x0001000000000000, 0x0000000000000001]
                    let shift = 16
                    let denormalized = remainder.denormalize(remainder: remainder, shift: shift)

                    expect(denormalized).to(equal(U128(from: [0x0001000100000000, 0x0000000000000000])))
                }

                it("should correctly denormalize with shift=1") {
                    let remainder = U128(from: [0x8000000000000000, 0x0000000000000001]) // [0x8000000000000000, 0x0000000000000001]
                    let shift = 1
                    let denormalized = remainder.denormalize(remainder: remainder, shift: shift)

                    expect(denormalized).to(equal(U128(from: [0xc000000000000000, 0x0000000000000000])))
                }

                it("should correctly denormalize with shift=63") {
                    let remainder = U128(from: [0x0000000000000001, 0x0000000000000001]) // [0x0000000000000001, 0x0000000000000001]
                    let shift = 63
                    let denormalized = remainder.denormalize(remainder: remainder, shift: shift)

                    expect(denormalized).to(equal(U128(from: [0x0000000000000002, 0x0000000000000000])))
                }

                it("should correctly denormalize with shift=64") {
                    let remainder = U128(from: [0x0000000100000000, 0x0000000000000001]) // [0x0000000100000000, 0x0000000000000001]
                    let shift = 64
                    let denormalized = remainder.denormalize(remainder: remainder, shift: shift)

                    expect(denormalized).to(equal(U128(from: [0x0000000000000001, 0x0000000000000000])))
                }
            }

            describe("U128.divRem(divisor:)") {
                context("when divisor is zero") {
                    it("should trigger a precondition failure") {
                        let dividend = U128(from: [0x1234567890abcdef, 0x0fedcba098765432])
                        let divisor = U128.ZERO

                        expect {
                            _ = dividend.divRem(divisor: divisor)
                        }.to(throwAssertion())
                    }
                }

                context("when self is less than divisor") {
                    it("should return zero quotient and self as remainder") {
                        let dividend = U128(from: [0x0000000000000001, 0x0000000000000000])
                        let divisor = U128(from: [0x0000000000000002, 0x0000000000000000])

                        let (quotient, remainder) = dividend.divRem(divisor: divisor)

                        expect(quotient).to(equal(U128.ZERO))
                        expect(remainder).to(equal(dividend))
                    }
                }

                context("when self is equal to divisor") {
                    it("should return one as quotient and zero as remainder") {
                        let dividend = U128(from: [0x0000000000000001, 0x0000000000000000])
                        let divisor = U128(from: [0x0000000000000001, 0x0000000000000000])

                        let (quotient, remainder) = dividend.divRem(divisor: divisor)

                        expect(quotient).to(equal(U128(from: [1, 0])))
                        expect(remainder).to(equal(U128.ZERO))
                    }
                }

                context("when divisor is one") {
                    it("should return self as quotient and zero as remainder") {
                        let dividend = U128(from: [0x1234567890abcdef, 0x0fedcba098765432])
                        let divisor = U128(from: [1, 0])

                        let (quotient, remainder) = dividend.divRem(divisor: divisor)

                        expect(quotient).to(equal(dividend))
                        expect(remainder).to(equal(U128.ZERO))
                    }
                }

                context("when divisor has leading zeros in high word") {
                    it("should correctly normalize and divide with shift=16") {
                        let dividend = U128(from: [0x0000000000000000, 0x0000ffff00000000])
                        let divisor = U128(from: [0x0000000000000000, 0x0000ffff00000000])

                        let (quotient, remainder) = dividend.divRem(divisor: divisor)

                        expect(quotient).to(equal(U128(from: [1, 0])))
                        expect(remainder).to(equal(U128.ZERO))
                    }
                }

                context("when division requires qHat adjustment") {
                    it("should correctly adjust qHat when initial qHat is overestimated") {
                        let dividend = U128(from: [0x0000000000000001, 0x8000000000000000])
                        let divisor = U128(from: [0x0000000000000002, 0x8000000000000000])

                        let (quotient, remainder) = dividend.divRem(divisor: divisor)

                        // Expected quotient = 0, remainder = dividend (since dividend < divisor)
                        expect(quotient).to(equal(U128.ZERO))
                        expect(remainder).to(equal(dividend))
                    }
                }

                context("when division involves multiple qHat adjustments") {
                    it("should correctly adjust qHat multiple times if necessary") {
                        let dividend = U128(from: [0x0000000000000000, 0x8000000000000000])
                        let divisor = U128(from: [0x0000000000000001, 0x0000000000000000])

                        let (quotient, remainder) = dividend.divRem(divisor: divisor)

                        // Expected quotient = 0x8000000000000000, remainder = 0
                        expect(quotient).to(equal(U128(from: [0x8000000000000000, 0x0000000000000000])))
                        expect(remainder).to(equal(U128.ZERO))
                    }
                }

                context("when division results in borrow adjustment") {
                    it("should correctly handle borrow during subtraction") {
                        let dividend = U128(from: [0x8000000000000000, 0x0000000000000001])
                        let divisor = U128(from: [0x8000000000000000, 0x0000000000000000])

                        let (quotient, remainder) = dividend.divRem(divisor: divisor)

                        // Expected quotient = 1, remainder = 0
                        expect(quotient).to(equal(U128(from: [1, 0])))
                        expect(remainder).to(equal(U128.ZERO))
                    }
                }

                context("when dividend has leading zeros in high word") {
                    it("should correctly normalize and divide with shift=32") {
                        let dividend = U128(from: [0x0000ffff00000000, 0x0000000000000000])
                        let divisor = U128(from: [0x0000ffff00000000, 0x0000000000000000])

                        let (quotient, remainder) = dividend.divRem(divisor: divisor)

                        expect(quotient).to(equal(U128(from: [1, 0])))
                        expect(remainder).to(equal(U128.ZERO))
                    }
                }

                context("when dividend is zero") {
                    it("should return zero quotient and zero remainder") {
                        let dividend = U128.ZERO
                        let divisor = U128(from: [0x0000000000000001, 0x0000000000000000])

                        let (quotient, remainder) = dividend.divRem(divisor: divisor)

                        expect(quotient).to(equal(U128.ZERO))
                        expect(remainder).to(equal(U128.ZERO))
                    }
                }

                context("when dividing maximum U128 value by itself") {
                    it("should return one as quotient and zero as remainder") {
                        let maxU128 = U128(from: [0xffffffffffffffff, 0xffffffffffffffff])
                        let divisor = U128(from: [0xffffffffffffffff, 0xffffffffffffffff])

                        let (quotient, remainder) = maxU128.divRem(divisor: divisor)

                        expect(quotient).to(equal(U128(from: [1, 0])))
                        expect(remainder).to(equal(U128.ZERO))
                    }
                }

                context("when dividing maximum U128 value by one") {
                    it("should return maximum U128 as quotient and zero as remainder") {
                        let maxU128 = U128(from: [0xffffffffffffffff, 0xffffffffffffffff])
                        let divisor = U128(from: [1, 0])

                        let (quotient, remainder) = maxU128.divRem(divisor: divisor)

                        expect(quotient).to(equal(maxU128))
                        expect(remainder).to(equal(U128.ZERO))
                    }
                }

                context("when divisor is greater than one but less than self") {
                    it("should correctly compute quotient and remainder") {
                        let dividend = U128(from: [0x0000000000000004, 0x0000000000000000]) // 4
                        let divisor = U128(from: [0x0000000000000002, 0x0000000000000000]) // 2

                        let (quotient, remainder) = dividend.divRem(divisor: divisor)

                        expect(quotient).to(equal(U128(from: [2, 0])))
                        expect(remainder).to(equal(U128.ZERO))
                    }
                }

                context("when dividend is not a multiple of divisor") {
                    it("should correctly compute quotient and remainder") {
                        let dividend = U128(from: [0x0000000000000005, 0x0000000000000000]) // 5
                        let divisor = U128(from: [0x0000000000000002, 0x0000000000000000]) // 2

                        let (quotient, remainder) = dividend.divRem(divisor: divisor)

                        expect(quotient).to(equal(U128(from: [2, 0])))
                        expect(remainder).to(equal(U128(from: [1, 0])))
                    }
                }

                context("when divisor has leading zeros and requires normalization") {
                    it("should correctly normalize and divide with shift=48") {
                        let dividend = U128(from: [0x00000000ffff0000, 0x0000000000000000])
                        let divisor = U128(from: [0x00000000ffff0000, 0x0000000000000000])

                        let (quotient, remainder) = dividend.divRem(divisor: divisor)

                        expect(quotient).to(equal(U128(from: [1, 0])))
                        expect(remainder).to(equal(U128.ZERO))
                    }
                }

                context("when high word of divisor is zero and requires additional shift") {
                    it("should correctly normalize and divide with shift=64 + leading zeros in low word") {
                        let dividend = U128(from: [0x0000000000000001, 0x0000000000000000]) // 1
                        let divisor = U128(from: [0x0000000000000001, 0x0000000000000000]) // 1

                        let (quotient, remainder) = dividend.divRem(divisor: divisor)

                        expect(quotient).to(equal(U128(from: [1, 0])))
                        expect(remainder).to(equal(U128.ZERO))
                    }
                }

                context("when divisor is larger than high word but fits in U128") {
                    it("should correctly compute quotient and remainder") {
                        let dividend = U128(from: [0xffffffffffffffff, 0x0000000000000001]) // 2^64 - 1 + 2^64 = 2^65 -1
                        let divisor = U128(from: [0x0000000000000002, 0x0000000000000000]) // 2

                        let (quotient, remainder) = dividend.divRem(divisor: divisor)

                        // Quotient = (2^65 -1) / 2 = 2^64 -1
                        // Remainder = 1
                        expect(quotient).to(equal(U128(from: [0xffffffffffffffff, 0x0000000000000000])))
                        expect(remainder).to(equal(U128(from: [1, 0])))
                    }
                }

                context("when dividend and divisor require maximum shift") {
                    it("should correctly normalize and divide with maximum shift") {
                        let dividend = U128(from: [0x0000000000000000, 0x8000000000000000]) // 2^127
                        let divisor = U128(from: [0x0000000000000001, 0x0000000000000000]) // 1

                        let (quotient, remainder) = dividend.divRem(divisor: divisor)

                        expect(quotient).to(equal(dividend))
                        expect(remainder).to(equal(U128.ZERO))
                    }
                }

                context("when dividend is multiple of divisor with high word") {
                    it("should correctly compute quotient and remainder") {
                        let dividend = U128(from: [0x0000000000000000, 0x0000000000000002]) // 2^64
                        let divisor = U128(from: [0x0000000000000001, 0x0000000000000001]) // 2^64 +1

                        let (quotient, remainder) = dividend.divRem(divisor: divisor)

                        // Since 2^64 < 2^64 +1, quotient =0, remainder=2^64
                        expect(quotient).to(equal(U128.ZERO))
                        expect(remainder).to(equal(dividend))
                    }
                }

                context("when divisor is much smaller than dividend") {
                    it("should correctly compute large quotient and small remainder") {
                        let dividend = U128(from: [0xffffffffffffffff, 0xffffffffffffffff]) // Maximum U128
                        let divisor = U128(from: [0x0000000000000001, 0x0000000000000000]) // 1

                        let (quotient, remainder) = dividend.divRem(divisor: divisor)

                        expect(quotient).to(equal(dividend))
                        expect(remainder).to(equal(U128.ZERO))
                    }
                }

                context("when dividend and divisor require partial normalization") {
                    it("should correctly normalize and divide with shift=1") {
                        let dividend = U128(from: [0x8000000000000000, 0x0000000000000001]) // 2^127 + 2^63
                        let divisor = U128(from: [0x8000000000000000, 0x0000000000000000]) // 2^63

                        let (quotient, remainder) = dividend.divRem(divisor: divisor)

                        // Expected quotient = 1, remainder = 0
                        expect(quotient).to(equal(U128(from: [1, 0])))
                        expect(remainder).to(equal(U128.ZERO))
                    }
                }

                context("when dividing") {
                    it("should correctly normalize and divide with shift=1") {
                        let dividend = U128(from: 2) * U128(from: [0x0000001fc0000000, 0x0000000000000000])
                        let divisor = U128(from: 2)
                        let (quotient, remainder) = dividend.divRem(divisor: divisor)

                        expect(quotient).to(equal(U128(from: [1, 0])))
                        expect(remainder).to(equal(U128.ZERO))
                    }

                    it("5 / 2") {
                        let dividend = U128(from: [5, 0])
                        let divisor = U128(from: [2, 0])
                        let (quotient, remainder) = dividend.divRem(divisor: divisor)

                        expect(quotient).to(equal(U128(from: [2, 0])))
                        expect(remainder).to(equal(U128(from: [1, 0])))
                    }
                }
            }
        }
    }
}