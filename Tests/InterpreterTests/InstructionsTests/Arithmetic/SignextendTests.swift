@testable import Interpreter
import Nimble
import PrimitiveTypes
import Quick

final class InstructionSignextendSpec: QuickSpec {
    @MainActor
    static let machine = TestMachine.machine(opcode: Opcode.SIGNEXTEND, gasLimit: 10)
    @MainActor
    static let machineLowGas = TestMachine.machine(opcode: Opcode.SIGNEXTEND, gasLimit: 2)

    override class func spec() {
        describe("Instruction Signextend") {
            it("40 sign") {
                var m = Self.machine

                let _ = m.stack.push(value: U256(from: 10))
                let _ = m.stack.push(value: U256(from: 40))

                m.evalLoop()
                let result = m.stack.pop()

                expect(m.machineStatus).to(equal(.Exit(.Success(.Stop))))
                expect(result).to(beSuccess { value in
                    expect(value).to(equal(U256(from: 10)))
                })
                expect(m.stack.length).to(equal(0))
                expect(m.gas.remaining).to(equal(5))
            }

            it("5 sign") {
                var m = Self.machine

                let _ = m.stack.push(value: U256(from: [3, 4, 5, 6]))
                let _ = m.stack.push(value: U256(from: 5))

                m.evalLoop()
                let result = m.stack.pop()

                expect(m.machineStatus).to(equal(.Exit(.Success(.Stop))))
                expect(result).to(beSuccess { value in
                    expect(value).to(equal(U256(from: [3, 0, 0, 0])))
                })
                expect(m.stack.length).to(equal(0))
                expect(m.gas.remaining).to(equal(5))
            }

            it("10 sign") {
                var m = Self.machine

                let _ = m.stack.push(value: U256(from: [3, 4, 5, 6]))
                let _ = m.stack.push(value: U256(from: 10))

                m.evalLoop()
                let result = m.stack.pop()

                expect(m.machineStatus).to(equal(.Exit(.Success(.Stop))))
                expect(result).to(beSuccess { value in
                    expect(value).to(equal(U256(from: [3, 4, 0, 0])))
                })
                expect(m.stack.length).to(equal(0))
                expect(m.gas.remaining).to(equal(5))
            }

            it("20 sign") {
                var m = Self.machine

                let _ = m.stack.push(value: U256(from: [3, 4, 5, 6]))
                let _ = m.stack.push(value: U256(from: 20))

                m.evalLoop()
                let result = m.stack.pop()

                expect(m.machineStatus).to(equal(.Exit(.Success(.Stop))))
                expect(result).to(beSuccess { value in
                    expect(value).to(equal(U256(from: [3, 4, 5, 0])))
                })
                expect(m.stack.length).to(equal(0))
                expect(m.gas.remaining).to(equal(5))
            }

            it("30 sign") {
                var m = Self.machine

                let _ = m.stack.push(value: U256(from: [3, 4, 5, 6]))
                let _ = m.stack.push(value: U256(from: 30))

                m.evalLoop()
                let result = m.stack.pop()

                expect(m.machineStatus).to(equal(.Exit(.Success(.Stop))))
                expect(result).to(beSuccess { value in
                    expect(value).to(equal(U256(from: [3, 4, 5, 6])))
                })
                expect(m.stack.length).to(equal(0))
                expect(m.gas.remaining).to(equal(5))
            }

            it("`a exp b`, when `b` not in the stack") {
                var m = Self.machine

                let _ = m.stack.push(value: U256(from: 1))
                m.evalLoop()

                expect(m.machineStatus).to(equal(.Exit(.Error(.StackUnderflow))))
                expect(m.stack.length).to(equal(0))
                expect(m.gas.remaining).to(equal(10))
            }

            it("(a exp 0)") {
                var m = Self.machine

                let _ = m.stack.push(value: U256(from: 0))
                let _ = m.stack.push(value: U256(from: 2))
                m.evalLoop()
                let result = m.stack.pop()

                expect(m.machineStatus).to(equal(.Exit(.Success(.Stop))))
                expect(result).to(beSuccess { value in
                    expect(value).to(equal(U256.ZERO))
                })
                expect(m.stack.length).to(equal(0))
                expect(m.gas.remaining).to(equal(5))
            }

            it("with OutOfGas result") {
                var m = Self.machineLowGas

                let _ = m.stack.push(value: U256(from: 1))
                let _ = m.stack.push(value: U256(from: 2))
                m.evalLoop()

                expect(m.machineStatus).to(equal(.Exit(.Error(.OutOfGas))))
                expect(m.stack.length).to(equal(0))
                expect(m.gas.remaining).to(equal(2))
            }

            it("check stack") {
                var m = Self.machine
                m.evalLoop()
                expect(m.machineStatus).to(equal(.Exit(.Error(.StackUnderflow))))

                var m1 = Self.machine
                let _ = m1.stack.push(value: U256(from: 5))
                m1.evalLoop()
                expect(m1.machineStatus).to(equal(.Exit(.Error(.StackUnderflow))))

                var m2 = Self.machine
                let _ = m2.stack.push(value: U256(from: 2))
                let _ = m2.stack.push(value: U256(from: 2))
                m2.evalLoop()
                expect(m2.machineStatus).to(equal(.Exit(.Success(.Stop))))
            }
        }
    }
}
