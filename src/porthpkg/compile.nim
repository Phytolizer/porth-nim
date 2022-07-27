from opcode import OpCode
from process import tryRunCmd
import emitter
import logging/log
import operation
import std/strformat
import std/options
import std/os

let dumpFilePath: string = getAppDir() / "csources" / "dump.c"

proc compileProgram*(program: seq[Operation], outFilePath: string) =
  let asmFilePath = outFilePath.changeFileExt("s")
  logInfo(fmt"Generating {asmFilePath}")
  var output = newEmitter(open(asmFilePath, fmWrite))

  output.indent()
  output.emit(".global main")
  output.emit(".text")
  output.dedent()
  output.emit("main:")
  output.indent()

  for ip in 0..<program.len:
    let op = program[ip]
    output.emit(fmt"# -- {op} --")
    output.dedent()
    output.emit(fmt".porth_addr_{ip}:")
    output.indent()
    case op.code
    of OP_PUSH:
      output.emit(fmt"push ${op.pushValue}")
    of OP_PLUS:
      output.emit("pop %rbx")
      output.emit("pop %rax")
      output.emit("add %rbx, %rax")
      output.emit("push %rax")
    of OP_MINUS:
      output.emit("pop %rbx")
      output.emit("pop %rax")
      output.emit("sub %rbx, %rax")
      output.emit("push %rax")
    of OP_EQUAL:
      output.emit("pop %rbx")
      output.emit("pop %rax")
      output.emit("cmp %rbx, %rax")
      output.emit("sete %al")
      output.emit("movsx %al, %rax")
      output.emit("push %rax")
    of OP_DUMP:
      output.emit("pop %rdi")
      output.emit("call porth_dump")
    of OP_IF:
      output.emit("pop %rax")
      output.emit("cmp $0, %rax")
      output.emit(fmt"je .porth_addr_{op.ifTarget.get}")
    of OP_ELSE:
      output.emit(fmt"jmp .porth_addr_{op.elseTarget.get}")
    of OP_END:
      output.emit("# nothing")

  output.emit("")
  output.emit("# -- end of program --")
  output.emit("mov $0, %rax")
  output.emit("ret")
  output.close()

  tryRunCmd("gcc", ["-o", outFilePath, asmFilePath, dumpFilePath])
