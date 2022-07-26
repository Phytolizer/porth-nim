import opcode
import operation

proc simulateProgram*(program: seq[Operation]) =
    var ip = 0
    var stack: seq[int64] = @[]
    while ip < program.len:
        let op = program[ip]
        case op.code
        of OpCode.PUSH:
            stack.add(op.pushValue)
            ip += 1
        of OpCode.PLUS:
            let b = stack.pop()
            let a = stack.pop()
            stack.add(a + b)
            ip += 1
        of OpCode.MINUS:
            let b = stack.pop()
            let a = stack.pop()
            stack.add(a - b)
            ip += 1
        of OpCode.EQUAL:
            let b = stack.pop()
            let a = stack.pop()
            stack.add(int64(a == b))
            ip += 1
        of OpCode.DUMP:
            let x = stack.pop()
            echo(x)
            ip += 1
