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
  of OP_WHILE:
    whileTarget*: Option[int]
  of OP_DO:
    doTarget*: Option[int]
  of OP_END:
    endTarget*: Option[int]
  else: discard

proc opPush*(token: Token, value: int64): Operation =
  Operation(
    token: token,
    code: OP_PUSH,
    pushValue: value,
  )

proc opDup*(token: Token): Operation =
  Operation(
    token: token,
    code: OP_DUP,
  )

proc opPop*(token: Token): Operation =
  Operation(
    token: token,
    code: OP_POP,
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

proc opGt*(token: Token): Operation =
  Operation(
    token: token,
    code: OP_GT,
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

proc opWhile*(token: Token): Operation =
  Operation(
    token: token,
    code: OP_WHILE,
    whileTarget: none[int](),
  )

proc opDo*(token: Token): Operation =
  Operation(
    token: token,
    code: OP_DO,
    doTarget: none[int](),
  )

proc opEnd*(token: Token): Operation =
  Operation(
    token: token,
    code: OP_END,
    endTarget: none[int](),
  )

proc `$`*(op: Operation): string =
  case op.code
  of OP_PUSH:
    fmt"OP_PUSH {op.pushValue}"
  else:
    $op.code
