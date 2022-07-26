from operation import Operation, plus, minus, dump, push
from std/strutils import parseInt
from token import Token

proc parseTokenAsOp*(token: Token): Operation =
    case token.text
    of "+":
        plus()
    of "-":
        minus()
    of ".":
        dump()
    else:
        let value = token.text.parseInt()
        push(value)
