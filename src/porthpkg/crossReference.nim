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
    of OP_WHILE:
      stack.add(ip)
    of OP_DO:
      if stack.len == 0:
        raise newParseError(op.token, "no enclosing block")
      let whileIp = stack.pop()
      if result[whileIp].code != OP_WHILE:
        raise newParseError(op.token, "no matching `while`")
      result[whileIp].whileTarget = some(ip)
      result[ip].doTarget = some(whileIp)
      stack.add(ip)
    of OP_END:
      if stack.len == 0:
        raise newParseError(op.token, "no enclosing block")
      let blockIp = stack.pop()
      case result[blockIp].code
      of OP_IF:
        result[blockIp].ifTarget = some(ip)
        result[ip].endTarget = some(ip + 1)
      of OP_ELSE:
        result[blockIp].elseTarget = some(ip)
        result[ip].endTarget = some(ip + 1)
      of OP_WHILE:
        result[blockIp].endTarget = some(ip)
        result[ip].endTarget = some(ip + 1)
      of OP_DO:
        let doTarget = result[blockIp].doTarget.get
        result[ip].endTarget = some(doTarget)
        result[blockIp].doTarget = some(ip + 1)
      else:
        # this will likely never appear as long as all blocks
        # may be closed by 'end'
        raise newParseError(op.token, "must close a compatible block")
    else:
      discard
  if stack.len != 0:
    raise newParseError(result[stack[^1]].token, "unclosed block")
