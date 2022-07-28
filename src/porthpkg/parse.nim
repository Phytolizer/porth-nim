from std/strutils import parseInt
from token import Token
import operation
import std/strformat

proc parseTokenAsOp*(token: Token): Operation =
  case token.text
  of "dup":
    return opDup(token)
  of "pop":
    return opPop(token)
  of "mem":
    return opMem(token)
  of ",":
    return opLoad(token)
  of ".":
    return opStore(token)
  of "syscall1":
    return opSyscall1(token)
  of "syscall2":
    return opSyscall2(token)
  of "syscall3":
    return opSyscall3(token)
  of "syscall4":
    return opSyscall4(token)
  of "syscall5":
    return opSyscall5(token)
  of "syscall6":
    return opSyscall6(token)
  of "+":
    return opPlus(token)
  of "-":
    return opMinus(token)
  of "=":
    return opEqual(token)
  of ">":
    return opGt(token)
  of "dump":
    return opDump(token)
  of "if":
    return opIf(token)
  of "else":
    return opElse(token)
  of "while":
    return opWhile(token)
  of "do":
    return opDo(token)
  of "end":
    return opEnd(token)
  else:
    try:
      let value = token.text.parseInt()
      return opPush(token, value)
    except ValueError:
      stderr.writeLine fmt"{token.filePath}:{token.line}:{token.column}: {getCurrentExceptionMsg()}"
      quit(1)
