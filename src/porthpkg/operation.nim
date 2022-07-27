from opcode import OpCode
import std/options
import std/strformat

type Operation* = object
  case code*: OpCode
  of OP_PUSH:
    pushValue*: int64
  of OP_IF:
    ifTarget*: Option[int]
  of OP_ELSE:
    elseTarget*: Option[int]
  else: discard

proc opPush*(value: int64): Operation =
  Operation(
    code: OP_PUSH,
    pushValue: value,
  )

proc opPlus*: Operation =
  Operation(
    code: OP_PLUS,
  )

proc opMinus*: Operation =
  Operation(
    code: OP_MINUS,
  )

proc opEqual*: Operation =
  Operation(
    code: OP_EQUAL,
  )

proc opDump*: Operation =
  Operation(
    code: OP_DUMP,
  )

proc opIf*: Operation =
  Operation(
    code: OP_IF,
    ifTarget: none[int](),
  )

proc opElse*: Operation =
  Operation(
    code: OP_ELSE,
    elseTarget: none[int](),
  )

proc opEnd*: Operation =
  Operation(
    code: OP_END,
  )

proc `$`*(op: Operation): string =
  case op.code
  of OP_PUSH:
    fmt"OP_PUSH {op.pushValue}"
  else:
    $op.code
