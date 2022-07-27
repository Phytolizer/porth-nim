import opcode
import operation
import std/options

proc simulateProgram*(program: seq[Operation]) =
  var ip = 0
  var stack: seq[int64] = @[]
  while ip < program.len:
    let op = program[ip]
    case op.code
    of OP_PUSH:
      stack.add(op.pushValue)
      ip += 1
    of OP_PLUS:
      let b = stack.pop()
      let a = stack.pop()
      stack.add(a + b)
      ip += 1
    of OP_MINUS:
      let b = stack.pop()
      let a = stack.pop()
      stack.add(a - b)
      ip += 1
    of OP_EQUAL:
      let b = stack.pop()
      let a = stack.pop()
      stack.add(int64(a == b))
      ip += 1
    of OP_DUMP:
      let x = stack.pop()
      echo(x)
      ip += 1
    of OP_IF:
      let a = stack.pop()
      if a == 0:
        assert op.ifTarget.isSome
        ip = op.ifTarget.get()
      else:
        ip += 1
    of OP_ELSE:
      assert op.elseTarget.isSome
      ip = op.elseTarget.get()
    of OP_END:
      ip += 1
