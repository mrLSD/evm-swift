@testable import Interpreter
import Nimble
import PrimitiveTypes
import Quick

final class InstructionAndSpec: QuickSpec {
    struct Handler: InterpreterHandler {
        func beforeOpcodeExecution(machine: inout Machine, opcode: Opcode, address: H160) -> Machine.ExitError? {
            nil
        }
    }

    override class func spec() {
        describe("Instruction AND") {
        }
    }
}

