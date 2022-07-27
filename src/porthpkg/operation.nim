from opcode import OpCode
import std/options
import std/strformat

type Operation* = object
  case code*: OpCode
  of OpCode.OP_PUSH:
    pushValue*: int64
  of OpCode.OP_IF:
    ifTarget*: Option[int]
  else: discard

proc opPush*(value: int64): Operation =
  Operation(
    code: OpCode.OP_PUSH,
    pushValue: value,
  )

proc opPlus*: Operation =
  Operation(
    code: OpCode.OP_PLUS,
  )

proc opMinus*: Operation =
  Operation(
    code: OpCode.OP_MINUS,
  )

proc opEqual*: Operation =
  Operation(
    code: OpCode.OP_EQUAL,
  )

proc opDump*: Operation =
  Operation(
    code: OpCode.OP_DUMP,
  )

proc opIf*: Operation =
  Operation(
    code: OpCode.OP_IF,
    ifTarget: none[int](),
  )

proc opEnd*: Operation =
  Operation(
    code: OpCode.OP_END,
  )

proc `$`*(op: Operation): string =
  case op.code
  of OpCode.OP_PUSH:
    fmt"OP_PUSH {op.pushValue}"
  else:
    $op.code
