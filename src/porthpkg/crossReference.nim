from operation import Operation
import opcode
import parseError
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
      if stack.len == 0:
        raise newParseError(op.token, "`else` without an enclosing block")
      let ifIp = stack.pop()
      if result[ifIp].code != OP_IF:
        raise newParseError(op.token, "`else` without `if`")
      result[ip].elseTarget = result[ifIp].ifTarget
      result[ifIp].ifTarget = some(ip + 1)
      stack.add(ip)
    of OP_END:
      if stack.len == 0:
        raise newParseError(op.token, "`end` without an enclosing block")
      let ifIp = stack.pop()
      case result[ifIp].code
      of OP_IF:
        result[ifIp].ifTarget = some(ip)
      of OP_ELSE:
        result[ifIp].elseTarget = some(ip)
      else:
        raise newParseError(op.token, "`end` must close an `if`/`else` block")
    else:
      discard
  if stack.len != 0:
    raise newParseError(result[stack[^1]].token, "unclosed block")
