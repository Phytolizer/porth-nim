from std/strutils import parseInt
from token import Token
import operation
import std/strformat

proc parseTokenAsOp*(token: Token): Operation =
  case token.text
  of "+":
    return opPlus()
  of "-":
    return opMinus()
  of "=":
    return opEqual()
  of ".":
    return opDump()
  of "if":
    return opIf()
  of "end":
    return opEnd()
  else:
    try:
      let value = token.text.parseInt()
      return opPush(value)
    except ValueError:
      stderr.writeLine fmt"{token.filePath}:{token.line}:{token.column}: {getCurrentExceptionMsg()}"
      quit(1)
