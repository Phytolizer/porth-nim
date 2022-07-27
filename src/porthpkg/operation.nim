from token import Token
import opcode
import std/options
import std/strformat

type Operation* = object
  token*: Token
  case code*: OpCode
  of OP_PUSH:
    pushValue*: int64
  of OP_IF:
    ifTarget*: Option[int]
  of OP_ELSE:
    elseTarget*: Option[int]
  else: discard

proc opPush*(token: Token, value: int64): Operation =
  Operation(
    token: token,
    code: OP_PUSH,
    pushValue: value,
  )

proc opPlus*(token: Token): Operation =
  Operation(
    token: token,
    code: OP_PLUS,
  )

proc opMinus*(token: Token): Operation =
  Operation(
    token: token,
    code: OP_MINUS,
  )

proc opEqual*(token: Token): Operation =
  Operation(
    token: token,
    code: OP_EQUAL,
  )

proc opDump*(token: Token): Operation =
  Operation(
    token: token,
    code: OP_DUMP,
  )

proc opIf*(token: Token): Operation =
  Operation(
    token: token,
    code: OP_IF,
    ifTarget: none[int](),
  )

proc opElse*(token: Token): Operation =
  Operation(
    token: token,
    code: OP_ELSE,
    elseTarget: none[int](),
  )

proc opEnd*(token: Token): Operation =
  Operation(
    token: token,
    code: OP_END,
  )

proc `$`*(op: Operation): string =
  case op.code
  of OP_PUSH:
    fmt"OP_PUSH {op.pushValue}"
  else:
    $op.code
