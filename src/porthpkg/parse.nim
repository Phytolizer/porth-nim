from std/strutils import parseInt
from token import Token
import operation
import std/strformat

proc parseTokenAsOp*(token: Token): Operation =
  case token.text
  of "+":
    return opPlus(token)
  of "-":
    return opMinus(token)
  of "=":
    return opEqual(token)
  of ".":
    return opDump(token)
  of "if":
    return opIf(token)
  of "else":
    return opElse(token)
  of "end":
    return opEnd(token)
  else:
    try:
      let value = token.text.parseInt()
      return opPush(token, value)
    except ValueError:
      stderr.writeLine fmt"{token.filePath}:{token.line}:{token.column}: {getCurrentExceptionMsg()}"
      quit(1)
