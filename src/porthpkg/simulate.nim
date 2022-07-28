import debug
import mem
import notImplemented
import opcode
import operation
import std/options
import std/streams
import std/strformat
import strconv

type SimulationError* = object of ValueError

proc simulateProgram*(program: seq[Operation], output: Stream = newFileStream(stdout)) =
  var ip = 0
  var stack: seq[int64] = @[]
  var memory = newSeq[byte](MEM_CAPACITY)
  while ip < program.len:
    let op = program[ip]
    when debugging:
      echo "----"
      echo fmt"stack: {stack}"
      echo $op
    case op.code
    of OP_PUSH:
      stack.add(op.pushValue)
      ip += 1
    of OP_DUP:
      stack.add(stack[^1])
      ip += 1
    of OP_2DUP:
      let b = stack.pop()
      let a = stack.pop()
      stack.add(a)
      stack.add(b)
      stack.add(a)
      stack.add(b)
      ip += 1
    of OP_DROP:
      discard stack.pop()
      ip += 1
    of OP_SWAP:
      let b = stack.pop()
      let a = stack.pop()
      stack.add(b)
      stack.add(a)
      ip += 1
    of OP_MEM:
      stack.add(0)
      ip += 1
    of OP_LOAD:
      let address = stack.pop()
      stack.add(int64(memory[address]))
      ip += 1
    of OP_STORE:
      let value = stack.pop()
      let address = stack.pop()
      memory[address] = cast[byte](value)
      ip += 1
    of OP_SYSCALL1:
      raise newNotImplementedDefect()
    of OP_SYSCALL2:
      raise newNotImplementedDefect()
    of OP_SYSCALL3:
      let syscallNumber = stack.pop()
      let arg1 = stack.pop()
      let arg2 = stack.pop()
      let arg3 = stack.pop()
      case syscallNumber
      of 1:
        let fd = arg1
        let buf = arg2
        let count = arg3
        let s = memory[buf..<buf + count].toString
        case fd
        of 1:
          output.write(s)
        of 2:
          stderr.write(s)
        else:
          raise newException(SimulationError, fmt"unknown file descriptor {fd}")
      else:
        raise newException(SimulationError, fmt"unknown syscall {syscallNumber}")
      ip += 1
    of OP_SYSCALL4:
      raise newNotImplementedDefect()
    of OP_SYSCALL5:
      raise newNotImplementedDefect()
    of OP_SYSCALL6:
      raise newNotImplementedDefect()
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
    of OP_LT:
      let b = stack.pop()
      let a = stack.pop()
      stack.add(int64(a < b))
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
