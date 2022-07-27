from opcode import OpCode
from operation import Operation
import std/options

func crossReferenceBlocks*(program: seq[Operation]): seq[Operation] =
  result = program
  var stack: seq[int] = @[]
  for ip in 0..<result.len:
    let op = result[ip]
    case op.code
    of OP_IF:
      stack.add(ip)
    of OP_ELSE:
      let ifIp = stack.pop()
      assert result[ifIp].code == OP_IF
      result[ip].elseTarget = result[ifIp].ifTarget
      result[ifIp].ifTarget = some(ip + 1)
      stack.add(ip)
    of OP_END:
      let ifIp = stack.pop()
      case result[ifIp].code
      of OP_IF:
        result[ifIp].ifTarget = some(ip)
      of OP_ELSE:
        result[ifIp].elseTarget = some(ip)
      else:
        assert false, "`end` must close an `if`/`else` block"
    else:
      discard
