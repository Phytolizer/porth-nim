from operation import Operation, plus, minus, dump, push
from std/strutils import parseInt
from token import Token
import std/strformat

proc parseTokenAsOp*(token: Token): Operation =
    case token.text
    of "+":
        return plus()
    of "-":
        return minus()
    of ".":
        return dump()
    else:
        try:
            let value = token.text.parseInt()
            return push(value)
        except ValueError:
            stderr.writeLine fmt"{token.filePath}:{token.line}:{token.column}: {getCurrentExceptionMsg()}"
            quit(1)
