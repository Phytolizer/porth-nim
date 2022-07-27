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

proc push*(value: int64): Operation =
  Operation(
    code: OpCode.OP_PUSH,
    pushValue: value,
  )

proc plus*: Operation =
  Operation(
    code: OpCode.OP_PLUS,
  )

proc minus*: Operation =
  Operation(
    code: OpCode.OP_MINUS,
  )

proc equal*: Operation =
  Operation(
    code: OpCode.OP_EQUAL,
  )

proc dump*: Operation =
  Operation(
    code: OpCode.OP_DUMP,
  )

proc iff*: Operation =
  Operation(
    code: OpCode.OP_IF,
    ifTarget: none[int](),
  )

proc endd*: Operation =
  Operation(
    code: OpCode.OP_END,
  )

proc `$`*(op: Operation): string =
  case op.code
  of OpCode.OP_PUSH:
    fmt"OP_PUSH {op.pushValue}"
  else:
    $op.code
