from operation import Operation, plus, minus, dump, push
from std/strutils import parseInt

proc parseTokenAsOp*(token: string): Operation =
    case token
    of "+":
        plus()
    of "-":
        minus()
    of ".":
        dump()
    else:
        let value = token.parseInt()
        push(value)
