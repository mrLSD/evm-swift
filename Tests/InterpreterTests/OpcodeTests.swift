import Nimble
import PrimitiveTypes
import Quick

@testable import Interpreter

final class InterpreterOpcodeSpec: QuickSpec {
    override class func spec() {
        describe("Opcode Enumeration") {
            context("Opcode rawValue") {
                it("should have correct rawValue for all Opcode cases") {
                    let opcodeRawValues: [Opcode: UInt8] = [
                        // Stop and Arithmetic
                        .STOP: 0x00,
                        .ADD: 0x01,
                        .MUL: 0x02,
                        .SUB: 0x03,
                        .DIV: 0x04,
                        .SDIV: 0x05,
                        .MOD: 0x06,
                        .SMOD: 0x07,
                        .ADDMOD: 0x08,
                        .MULMOD: 0x09,
                        .EXP: 0x0a,
                        .SIGNEXTEND: 0x0b,

                        // Comparison and Bitwise Logic
                        .LT: 0x10,
                        .GT: 0x11,
                        .SLT: 0x12,
                        .SGT: 0x13,
                        .EQ: 0x14,
                        .ISZERO: 0x15,
                        .AND: 0x16,
                        .OR: 0x17,
                        .XOR: 0x18,
                        .NOT: 0x19,
                        .BYTE: 0x1a,
                        .SHL: 0x1b,
                        .SHR: 0x1c,
                        .SAR: 0x1d,

                        // Sha3
                        .SHA3: 0x20,

                        // Environment Information
                        .ADDRESS: 0x30,
                        .BALANCE: 0x31,
                        .ORIGIN: 0x32,
                        .CALLER: 0x33,
                        .CALLVALUE: 0x34,
                        .CALLDATALOAD: 0x35,
                        .CALLDATASIZE: 0x36,
                        .CALLDATACOPY: 0x37,
                        .CODESIZE: 0x38,
                        .CODECOPY: 0x39,
                        .GASPRICE: 0x3a,
                        .EXTCODESIZE: 0x3b,
                        .EXTCODECOPY: 0x3c,
                        .RETURNDATASIZE: 0x3d,
                        .RETURNDATACOPY: 0x3e,
                        .EXTCODEHASH: 0x3f,

                        // Block Information
                        .BLOCKHASH: 0x40,
                        .COINBASE: 0x41,
                        .TIMESTAMP: 0x42,
                        .NUMBER: 0x43,
                        .PREVRANDAO: 0x44,
                        .GASLIMIT: 0x45,

                        // Additional Block Information
                        .CHAINID: 0x46,
                        .SELFBALANCE: 0x47,
                        .BASEFEE: 0x48,
                        .BLOBHASH: 0x49,
                        .BLOBBASEFEE: 0x4a,

                        // Stack, Memory, Storage and Flow Operations
                        .POP: 0x50,
                        .MLOAD: 0x51,
                        .MSTORE: 0x52,
                        .MSTORE8: 0x53,
                        .SLOAD: 0x54,
                        .SSTORE: 0x55,
                        .JUMP: 0x56,
                        .JUMPI: 0x57,
                        .PC: 0x58,
                        .MSIZE: 0x59,
                        .GAS: 0x5a,
                        .JUMPDEST: 0x5b,
                        .TLOAD: 0x5c,
                        .TSTORE: 0x5d,
                        .MCOPY: 0x5e,

                        // Push Operations
                        .PUSH0: 0x5f,
                        .PUSH1: 0x60,
                        .PUSH2: 0x61,
                        .PUSH3: 0x62,
                        .PUSH4: 0x63,
                        .PUSH5: 0x64,
                        .PUSH6: 0x65,
                        .PUSH7: 0x66,
                        .PUSH8: 0x67,
                        .PUSH9: 0x68,
                        .PUSH10: 0x69,
                        .PUSH11: 0x6a,
                        .PUSH12: 0x6b,
                        .PUSH13: 0x6c,
                        .PUSH14: 0x6d,
                        .PUSH15: 0x6e,
                        .PUSH16: 0x6f,
                        .PUSH17: 0x70,
                        .PUSH18: 0x71,
                        .PUSH19: 0x72,
                        .PUSH20: 0x73,
                        .PUSH21: 0x74,
                        .PUSH22: 0x75,
                        .PUSH23: 0x76,
                        .PUSH24: 0x77,
                        .PUSH25: 0x78,
                        .PUSH26: 0x79,
                        .PUSH27: 0x7a,
                        .PUSH28: 0x7b,
                        .PUSH29: 0x7c,
                        .PUSH30: 0x7d,
                        .PUSH31: 0x7e,
                        .PUSH32: 0x7f,

                        // Duplicate Operations
                        .DUP1: 0x80,
                        .DUP2: 0x81,
                        .DUP3: 0x82,
                        .DUP4: 0x83,
                        .DUP5: 0x84,
                        .DUP6: 0x85,
                        .DUP7: 0x86,
                        .DUP8: 0x87,
                        .DUP9: 0x88,
                        .DUP10: 0x89,
                        .DUP11: 0x8a,
                        .DUP12: 0x8b,
                        .DUP13: 0x8c,
                        .DUP14: 0x8d,
                        .DUP15: 0x8e,
                        .DUP16: 0x8f,

                        // Exchange Operations
                        .SWAP1: 0x90,
                        .SWAP2: 0x91,
                        .SWAP3: 0x92,
                        .SWAP4: 0x93,
                        .SWAP5: 0x94,
                        .SWAP6: 0x95,
                        .SWAP7: 0x96,
                        .SWAP8: 0x97,
                        .SWAP9: 0x98,
                        .SWAP10: 0x99,
                        .SWAP11: 0x9a,
                        .SWAP12: 0x9b,
                        .SWAP13: 0x9c,
                        .SWAP14: 0x9d,
                        .SWAP15: 0x9e,
                        .SWAP16: 0x9f,

                        // Logging
                        .LOG0: 0xa0,
                        .LOG1: 0xa1,
                        .LOG2: 0xa2,
                        .LOG3: 0xa3,
                        .LOG4: 0xa4,

                        // EOF Data instructions
                        .DATALOAD: 0xd0,
                        .DATALOADN: 0xd1,
                        .DATASIZE: 0xd2,
                        .DATACOPY: 0xd3,

                        // EOFv1 instructions
                        .RJUMP: 0xe0,
                        .RJUMPI: 0xe1,
                        .RJUMPV: 0xe2,
                        .CALLF: 0xe3,
                        .RETF: 0xe4,
                        .JUMPF: 0xe5,
                        .DUPN: 0xe6,
                        .SWAPN: 0xe7,
                        .EXCHANGE: 0xe8,
                        .EOFCREATE: 0xec,
                        .RETURNCONTRACT: 0xee,

                        // System
                        .CREATE: 0xf0,
                        .CALL: 0xf1,
                        .CALLCODE: 0xf2,
                        .RETURN: 0xf3,
                        .DELEGATECALL: 0xf4,
                        .CREATE2: 0xf5,
                        .RETURNDATALOAD: 0xf7,
                        .EXTCALL: 0xf8,
                        .EXTDELEGATECALL: 0xf9,
                        .STATICCALL: 0xfa,
                        .EXTSTATICCALL: 0xfb,
                        .REVERT: 0xfd,
                        .INVALID: 0xfe,
                        .SELFDESTRUCT: 0xff,
                    ]

                    for (opcode, rawValue) in opcodeRawValues {
                        expect(opcode.rawValue).to(
                            equal(rawValue),
                            description:
                            "Opcode \(opcode) should have rawValue \(String(format: "0x%02X", rawValue))")
                    }
                }
            }

            // Test for description of each case
            context("description") {
                it("should return correct description for all Opcode cases") {
                    let opcodeDescriptions: [Opcode: String] = [
                        // Stop and Arithmetic
                        .STOP: "STOP",
                        .ADD: "ADD",
                        .MUL: "MUL",
                        .SUB: "SUB",
                        .DIV: "DIV",
                        .SDIV: "SDIV",
                        .MOD: "MOD",
                        .SMOD: "SMOD",
                        .ADDMOD: "ADDMOD",
                        .MULMOD: "MULMOD",
                        .EXP: "EXP",
                        .SIGNEXTEND: "SIGNEXTEND",

                        // Comparison and Bitwise Logic
                        .LT: "LT",
                        .GT: "GT",
                        .SLT: "SLT",
                        .SGT: "SGT",
                        .EQ: "EQ",
                        .ISZERO: "ISZERO",
                        .AND: "AND",
                        .OR: "OR",
                        .XOR: "XOR",
                        .NOT: "NOT",
                        .BYTE: "BYTE",
                        .SHL: "SHL",
                        .SHR: "SHR",
                        .SAR: "SAR",

                        // Sha3
                        .SHA3: "SHA3",

                        // Environment Information
                        .ADDRESS: "ADDRESS",
                        .BALANCE: "BALANCE",
                        .ORIGIN: "ORIGIN",
                        .CALLER: "CALLER",
                        .CALLVALUE: "CALLVALUE",
                        .CALLDATALOAD: "CALLDATALOAD",
                        .CALLDATASIZE: "CALLDATASIZE",
                        .CALLDATACOPY: "CALLDATACOPY",
                        .CODESIZE: "CODESIZE",
                        .CODECOPY: "CODECOPY",
                        .GASPRICE: "GASPRICE",
                        .EXTCODESIZE: "EXTCODESIZE",
                        .EXTCODECOPY: "EXTCODECOPY",
                        .RETURNDATASIZE: "RETURNDATASIZE",
                        .RETURNDATACOPY: "RETURNDATACOPY",
                        .EXTCODEHASH: "EXTCODEHASH",

                        // Block Information
                        .BLOCKHASH: "BLOCKHASH",
                        .COINBASE: "COINBASE",
                        .TIMESTAMP: "TIMESTAMP",
                        .NUMBER: "NUMBER",
                        .PREVRANDAO: "PREVRANDAO",
                        .GASLIMIT: "GASLIMIT",

                        // Additional Block Information
                        .CHAINID: "CHAINID",
                        .SELFBALANCE: "SELFBALANCE",
                        .BASEFEE: "BASEFEE",
                        .BLOBHASH: "BLOBHASH",
                        .BLOBBASEFEE: "BLOBBASEFEE",

                        // Stack, Memory, Storage and Flow Operations
                        .POP: "POP",
                        .MLOAD: "MLOAD",
                        .MSTORE: "MSTORE",
                        .MSTORE8: "MSTORE8",
                        .SLOAD: "SLOAD",
                        .SSTORE: "SSTORE",
                        .JUMP: "JUMP",
                        .JUMPI: "JUMPI",
                        .PC: "PC",
                        .MSIZE: "MSIZE",
                        .GAS: "GAS",
                        .JUMPDEST: "JUMPDEST",
                        .TLOAD: "TLOAD",
                        .TSTORE: "TSTORE",
                        .MCOPY: "MCOPY",

                        // Push Operations
                        .PUSH0: "PUSH0",
                        .PUSH1: "PUSH1",
                        .PUSH2: "PUSH2",
                        .PUSH3: "PUSH3",
                        .PUSH4: "PUSH4",
                        .PUSH5: "PUSH5",
                        .PUSH6: "PUSH6",
                        .PUSH7: "PUSH7",
                        .PUSH8: "PUSH8",
                        .PUSH9: "PUSH9",
                        .PUSH10: "PUSH10",
                        .PUSH11: "PUSH11",
                        .PUSH12: "PUSH12",
                        .PUSH13: "PUSH13",
                        .PUSH14: "PUSH14",
                        .PUSH15: "PUSH15",
                        .PUSH16: "PUSH16",
                        .PUSH17: "PUSH17",
                        .PUSH18: "PUSH18",
                        .PUSH19: "PUSH19",
                        .PUSH20: "PUSH20",
                        .PUSH21: "PUSH21",
                        .PUSH22: "PUSH22",
                        .PUSH23: "PUSH23",
                        .PUSH24: "PUSH24",
                        .PUSH25: "PUSH25",
                        .PUSH26: "PUSH26",
                        .PUSH27: "PUSH27",
                        .PUSH28: "PUSH28",
                        .PUSH29: "PUSH29",
                        .PUSH30: "PUSH30",
                        .PUSH31: "PUSH31",
                        .PUSH32: "PUSH32",

                        // Duplicate Operations
                        .DUP1: "DUP1",
                        .DUP2: "DUP2",
                        .DUP3: "DUP3",
                        .DUP4: "DUP4",
                        .DUP5: "DUP5",
                        .DUP6: "DUP6",
                        .DUP7: "DUP7",
                        .DUP8: "DUP8",
                        .DUP9: "DUP9",
                        .DUP10: "DUP10",
                        .DUP11: "DUP11",
                        .DUP12: "DUP12",
                        .DUP13: "DUP13",
                        .DUP14: "DUP14",
                        .DUP15: "DUP15",
                        .DUP16: "DUP16",

                        // Exchange Operations
                        .SWAP1: "SWAP1",
                        .SWAP2: "SWAP2",
                        .SWAP3: "SWAP3",
                        .SWAP4: "SWAP4",
                        .SWAP5: "SWAP5",
                        .SWAP6: "SWAP6",
                        .SWAP7: "SWAP7",
                        .SWAP8: "SWAP8",
                        .SWAP9: "SWAP9",
                        .SWAP10: "SWAP10",
                        .SWAP11: "SWAP11",
                        .SWAP12: "SWAP12",
                        .SWAP13: "SWAP13",
                        .SWAP14: "SWAP14",
                        .SWAP15: "SWAP15",
                        .SWAP16: "SWAP16",

                        // Logging
                        .LOG0: "LOG0",
                        .LOG1: "LOG1",
                        .LOG2: "LOG2",
                        .LOG3: "LOG3",
                        .LOG4: "LOG4",

                        // EOF Data instructions
                        .DATALOAD: "DATALOAD",
                        .DATALOADN: "DATALOADN",
                        .DATASIZE: "DATASIZE",
                        .DATACOPY: "DATACOPY",

                        // EOFv1 instructions
                        .RJUMP: "RJUMP",
                        .RJUMPI: "RJUMPI",
                        .RJUMPV: "RJUMPV",
                        .CALLF: "CALLF",
                        .RETF: "RETF",
                        .JUMPF: "JUMPF",
                        .DUPN: "DUPN",
                        .SWAPN: "SWAPN",
                        .EXCHANGE: "EXCHANGE",
                        .EOFCREATE: "EOFCREATE",
                        .RETURNCONTRACT: "RETURNCONTRACT",

                        // System
                        .CREATE: "CREATE",
                        .CALL: "CALL",
                        .CALLCODE: "CALLCODE",
                        .RETURN: "RETURN",
                        .DELEGATECALL: "DELEGATECALL",
                        .CREATE2: "CREATE2",
                        .RETURNDATALOAD: "RETURNDATALOAD",
                        .EXTCALL: "EXTCALL",
                        .EXTDELEGATECALL: "EXTDELEGATECALL",
                        .STATICCALL: "STATICCALL",
                        .EXTSTATICCALL: "EXTSTATICCALL",
                        .REVERT: "REVERT",
                        .INVALID: "INVALID",
                        .SELFDESTRUCT: "SELFDESTRUCT",
                    ]

                    for (opcode, description) in opcodeDescriptions {
                        expect(opcode.name).to(
                            equal(description),
                            description:
                            "Opcode \(opcode) should have description \"\(description)\"")
                    }
                }
            }

            // Additional Test: Ensure all opcodes have unique rawValues
            context("uniqueness of rawValue") {
                it("should have unique rawValue for each Opcode case") {
                    let allRawValues = Opcode.allCases.map(\.rawValue)
                    let uniqueRawValues = Set(allRawValues)
                    expect(uniqueRawValues.count).to(
                        equal(allRawValues.count),
                        description: "All Opcode rawValues should be unique")
                }
            }
        }
    }
}

// Extension to make Opcode conform to CaseIterable for testing purposes
extension Opcode: CaseIterable {
    public static var allCases: [Opcode] {
        [
            // Stop and Arithmetic
            .STOP, .ADD, .MUL, .SUB, .DIV, .SDIV, .MOD, .SMOD, .ADDMOD, .MULMOD, .EXP, .SIGNEXTEND,

            // Comparison and Bitwise Logic
            .LT, .GT, .SLT, .SGT, .EQ, .ISZERO, .AND, .OR, .XOR, .NOT, .BYTE, .SHL, .SHR, .SAR,

            // Sha3
            .SHA3,

            // Environment Information
            .ADDRESS, .BALANCE, .ORIGIN, .CALLER, .CALLVALUE, .CALLDATALOAD, .CALLDATASIZE,
            .CALLDATACOPY, .CODESIZE, .CODECOPY, .GASPRICE, .EXTCODESIZE, .EXTCODECOPY,
            .RETURNDATASIZE, .RETURNDATACOPY, .EXTCODEHASH,

            // Block Information
            .BLOCKHASH, .COINBASE, .TIMESTAMP, .NUMBER, .PREVRANDAO, .GASLIMIT,

            // Additional Block Information
            .CHAINID, .SELFBALANCE, .BASEFEE, .BLOBHASH, .BLOBBASEFEE,

            // Stack, Memory, Storage and Flow Operations
            .POP, .MLOAD, .MSTORE, .MSTORE8, .SLOAD, .SSTORE, .JUMP, .JUMPI, .PC, .MSIZE, .GAS,
            .JUMPDEST, .TLOAD, .TSTORE, .MCOPY,

            // Push Operations
            .PUSH0, .PUSH1, .PUSH2, .PUSH3, .PUSH4, .PUSH5, .PUSH6, .PUSH7, .PUSH8, .PUSH9, .PUSH10,
            .PUSH11, .PUSH12, .PUSH13, .PUSH14, .PUSH15, .PUSH16, .PUSH17, .PUSH18, .PUSH19,
            .PUSH20, .PUSH21, .PUSH22, .PUSH23, .PUSH24, .PUSH25, .PUSH26, .PUSH27, .PUSH28,
            .PUSH29, .PUSH30, .PUSH31, .PUSH32,

            // Duplicate Operations
            .DUP1, .DUP2, .DUP3, .DUP4, .DUP5, .DUP6, .DUP7, .DUP8, .DUP9, .DUP10, .DUP11, .DUP12,
            .DUP13, .DUP14, .DUP15, .DUP16,

            // Exchange Operations
            .SWAP1, .SWAP2, .SWAP3, .SWAP4, .SWAP5, .SWAP6, .SWAP7, .SWAP8, .SWAP9, .SWAP10,
            .SWAP11, .SWAP12, .SWAP13, .SWAP14, .SWAP15, .SWAP16,

            // Logging
            .LOG0, .LOG1, .LOG2, .LOG3, .LOG4,

            // EOF Data instructions
            .DATALOAD, .DATALOADN, .DATASIZE, .DATACOPY,

            // EOFv1 instructions
            .RJUMP, .RJUMPI, .RJUMPV, .CALLF, .RETF, .JUMPF, .DUPN, .SWAPN, .EXCHANGE, .EOFCREATE,
            .RETURNCONTRACT,

            // System
            .CREATE, .CALL, .CALLCODE, .RETURN, .DELEGATECALL, .CREATE2, .RETURNDATALOAD, .EXTCALL,
            .EXTDELEGATECALL, .STATICCALL, .EXTSTATICCALL, .REVERT, .INVALID, .SELFDESTRUCT,
        ]
    }
}
