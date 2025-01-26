@testable import Interpreter
import Nimble
import PrimitiveTypes
import Quick

final class InstructionSubSpec: QuickSpec {
    @MainActor
    static let machine = TestMachine.machine(opcode: Opcode.SUB, gasLimit: 10)
    @MainActor
    static let machineLowGas = TestMachine.machine(opcode: Opcode.SUB, gasLimit: 2)

    override class func spec() {
        describe("Instruction Sub") {
            it("3 - 2") {
                var m = Self.machine

                let _ = m.stack.push(value: U256(from: 2))
                let _ = m.stack.push(value: U256(from: 3))
                m.evalLoop()
                let result = m.stack.pop()

                expect(m.machineStatus).to(equal(.Exit(.Success(.Stop))))
                expect(result).to(beSuccess { value in
                    expect(value).to(equal(U256(from: 1)))
                })
                expect(m.stack.length).to(equal(0))
                expect(m.gas.remaining).to(equal(7))
            }

            it("5 - 10 with overflow") {
                var m = Self.machine

                let _ = m.stack.push(value: U256(from: 10))
                let _ = m.stack.push(value: U256(from: 5))
                m.evalLoop()
                let result = m.stack.pop()

                expect(m.machineStatus).to(equal(.Exit(.Success(.Stop))))
                expect(result).to(beSuccess { value in
                    expect(value).to(equal(U256(from: [UInt64.max-4, UInt64.max, UInt64.max, UInt64.max])))
                })
                expect(m.stack.length).to(equal(0))
                expect(m.gas.remaining).to(equal(7))
            }

            it("`a - b`, when `b` not in the stack") {
                var m = Self.machine

                let _ = m.stack.push(value: U256(from: 3))
                m.evalLoop()

                expect(m.machineStatus).to(equal(.Exit(.Error(.StackUnderflow))))
                expect(m.stack.length).to(equal(0))
                expect(m.gas.remaining).to(equal(7))
            }

            it("max values") {
                var m = Self.machine

                let _ = m.stack.push(value: U256(from: [UInt64.max-9, UInt64.max-6, UInt64.max-4, UInt64.max-2]))
                let _ = m.stack.push(value: U256(from: [UInt64.max-5, UInt64.max-3, UInt64.max-2, UInt64.max-1]))
                m.evalLoop()
                let result = m.stack.pop()

                expect(m.machineStatus).to(equal(.Exit(.Success(.Stop))))
                expect(result).to(beSuccess { value in
                    expect(value).to(equal(U256(from: [4, 3, 2, 1])))
                })
                expect(m.stack.length).to(equal(0))
                expect(m.gas.remaining).to(equal(7))
            }

            it("with OutOfGas result") {
                var m = Self.machineLowGas

                let _ = m.stack.push(value: U256(from: 3))
                let _ = m.stack.push(value: U256(from: 2))
                m.evalLoop()

                expect(m.machineStatus).to(equal(.Exit(.Error(.OutOfGas))))
                expect(m.stack.length).to(equal(2))
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
