from opcode import OpCode
from operation import Operation
import std/options

func crossReferenceBlocks*(program: seq[Operation]): seq[Operation] =
  result = program
  var stack: seq[int] = @[]
  for ip in 0..<result.len:
    let op = result[ip]
    case op.code
    of OpCode.OP_IF:
      stack.add(ip)
    of OpCode.OP_END:
      let ifIp = stack.pop()
      assert result[ifIp].code == OpCode.OP_IF
      result[ifIp].ifTarget = some(ip)
    else:
      discard
