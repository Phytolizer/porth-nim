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

proc op2dup*(token: Token): Operation =
  Operation(
    token: token,
    code: OP_2DUP,
  )

proc opDrop*(token: Token): Operation =
  Operation(
    token: token,
    code: OP_DROP,
  )

proc opSwap*(token: Token): Operation =
  Operation(
    token: token,
    code: OP_SWAP,
  )

proc opMem*(token: Token): Operation =
  Operation(
    token: token,
    code: OP_MEM,
  )

proc opLoad*(token: Token): Operation =
  Operation(
    token: token,
    code: OP_LOAD,
  )

proc opStore*(token: Token): Operation =
  Operation(
    token: token,
    code: OP_STORE,
  )

proc opSyscall1*(token: Token): Operation =
  Operation(
    token: token,
    code: OP_SYSCALL1,
  )

proc opSyscall2*(token: Token): Operation =
  Operation(
    token: token,
    code: OP_SYSCALL2,
  )

proc opSyscall3*(token: Token): Operation =
  Operation(
    token: token,
    code: OP_SYSCALL3,
  )

proc opSyscall4*(token: Token): Operation =
  Operation(
    token: token,
    code: OP_SYSCALL4,
  )

proc opSyscall5*(token: Token): Operation =
  Operation(
    token: token,
    code: OP_SYSCALL5,
  )

proc opSyscall6*(token: Token): Operation =
  Operation(
    token: token,
    code: OP_SYSCALL6,
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

proc opLt*(token: Token): Operation =
  Operation(
    token: token,
    code: OP_LT,
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
