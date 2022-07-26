from opcode import OpCode
from process import tryRunCmd
import emitter
import operation
import std/strformat
import std/os

let dumpFilePath: string = getAppDir() / "csources" / "dump.c"

proc compileProgram*(program: seq[Operation], outFilePath: string) =
  let asmFilePath = outFilePath.changeFileExt("s")
  var output = newEmitter(open(asmFilePath, fmWrite))

  output.indent()
  output.emit(".global main")
  output.emit(".text")
  output.dedent()
  output.emit("main:")
  output.indent()

  for op in program:
    output.emit(fmt"## -- {op} --")
    case op.code
    of OpCode.PUSH:
      output.emit(fmt"push ${op.pushValue}")
    of OpCode.PLUS:
      output.emit("pop %rbx")
      output.emit("pop %rax")
      output.emit("add %rbx, %rax")
      output.emit("push %rax")
    of OpCode.MINUS:
      output.emit("pop %rbx")
      output.emit("pop %rax")
      output.emit("sub %rbx, %rax")
      output.emit("push %rax")
    of OpCode.EQUAL:
      output.emit("pop %rbx")
      output.emit("pop %rax")
      output.emit("cmp %rbx, %rax")
      output.emit("sete %al")
      output.emit("movsx %al, %rax")
      output.emit("push %rax")
    of OpCode.DUMP:
      output.emit("pop %rdi")
      output.emit("call porth_dump")

  output.emit("mov $0, %rax")
  output.emit("ret")
  output.close()

  tryRunCmd("gcc", ["-o", outFilePath, asmFilePath, dumpFilePath])
