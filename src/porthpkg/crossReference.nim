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
        raise newParseError(op.token, "no enclosing block")
      let ifIp = stack.pop()
      if result[ifIp].code != OP_IF:
        raise newParseError(op.token, "no matching `if`")
      result[ip].elseTarget = result[ifIp].ifTarget
      result[ifIp].ifTarget = some(ip + 1)
      stack.add(ip)
    of OP_END:
      if stack.len == 0:
        raise newParseError(op.token, "no enclosing block")
      let blockIp = stack.pop()
      case result[blockIp].code
      of OP_IF:
        result[blockIp].ifTarget = some(ip)
      of OP_ELSE:
        result[blockIp].elseTarget = some(ip)
      else:
        # this will likely never appear as long as all blocks
        # may be closed by 'end'
        raise newParseError(op.token, "must close a compatible block")
    else:
      discard
  if stack.len != 0:
    raise newParseError(result[stack[^1]].token, "unclosed block")
