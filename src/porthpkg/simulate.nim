import opcode
import operation
import std/options
import std/streams

proc simulateProgram*(program: seq[Operation], output: Stream = newFileStream(stdout)) =
  var ip = 0
  var stack: seq[int64] = @[]
  while ip < program.len:
    let op = program[ip]
    case op.code
    of OP_PUSH:
      stack.add(op.pushValue)
      ip += 1
    of OP_DUP:
      stack.add(stack[^1])
      ip += 1
    of OP_POP:
      discard stack.pop()
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
    of OP_GT:
      let b = stack.pop()
      let a = stack.pop()
      stack.add(int64(a > b))
      ip += 1
    of OP_DUMP:
      let x = stack.pop()
      output.writeLine(x)
      ip += 1
    of OP_IF:
      let x = stack.pop()
      if x == 0:
        assert op.ifTarget.isSome
        ip = op.ifTarget.get()
      else:
        ip += 1
    of OP_ELSE:
      assert op.elseTarget.isSome
      ip = op.elseTarget.get()
    of OP_WHILE:
      ip += 1
    of OP_DO:
      let x = stack.pop()
      if x == 0:
        assert op.doTarget.isSome
        ip = op.doTarget.get()
      else:
        ip += 1
    of OP_END:
      assert op.endTarget.isSome
      ip = op.endTarget.get()
