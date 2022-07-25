from opcode import OpCode
import std/strformat

type Operation* = object
    case code*: OpCode
    of OpCode.PUSH:
        pushValue*: int64
    else: discard

proc push*(value: int64): Operation =
    Operation(
        code: OpCode.PUSH,
        pushValue: value,
    )

proc plus*: Operation =
    Operation(
        code: OpCode.PLUS,
    )

proc minus*: Operation =
    Operation(
        code: OpCode.MINUS,
    )

proc dump*: Operation =
    Operation(
        code: OpCode.DUMP,
    )

proc `$`*(op: Operation): string =
    case op.code
    of OpCode.PUSH:
        fmt"PUSH {op.pushValue}"
    else:
        $op.code
