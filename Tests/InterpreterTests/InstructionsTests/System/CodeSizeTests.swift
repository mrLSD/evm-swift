@testable import Interpreter
import Nimble
import PrimitiveTypes
import Quick

final class InstructionCodeSizeSpec: QuickSpec {
    @MainActor
    static let machineLowGas = TestMachine.machine(opcode: Opcode.CODESIZE, gasLimit: 1)

    override class func spec() {
        describe("Instruction CODESIZE") {
            it("size = 1") {
                var m = TestMachine.machine(opcode: Opcode.CODESIZE, gasLimit: 10)

                m.evalLoop()

                expect(m.machineStatus).to(equal(.Exit(.Success(.Stop))))

                let result = m.stack.pop()
                expect(result).to(beSuccess { value in
                    expect(value).to(equal(U256(from: 1)))
                })

                expect(m.stack.length).to(equal(0))
                expect(m.gas.remaining).to(equal(8))
            }

            it("size = 4") {
                var m = TestMachine.machine(opcodes: [Opcode.CODESIZE, Opcode.CODESIZE, Opcode.CODESIZE, Opcode.CODESIZE], gasLimit: 10)

                m.evalLoop()

                expect(m.machineStatus).to(equal(.Exit(.Success(.Stop))))

                for _ in 0 ..< 4 {
                    let result = m.stack.pop()
                    expect(result).to(beSuccess { value in
                        expect(value).to(equal(U256(from: 4)))
                    })
                }

                expect(m.stack.length).to(equal(0))
                expect(m.gas.remaining).to(equal(2))
            }

            it("with OutOfGas result") {
                var m = Self.machineLowGas

                m.evalLoop()

                expect(m.machineStatus).to(equal(.Exit(.Error(.OutOfGas))))
                expect(m.stack.length).to(equal(0))
                expect(m.gas.remaining).to(equal(1))
            }

            it("check stack overflow") {
                var m = TestMachine.machine(opcode: Opcode.CODESIZE, gasLimit: 10)
                for _ in 0 ..< m.stack.limit {
                    let _ = m.stack.push(value: U256(from: 5))
                }

                m.evalLoop()
                expect(m.machineStatus).to(equal(.Exit(.Error(.StackOverflow))))
            }
        }
    }
}
