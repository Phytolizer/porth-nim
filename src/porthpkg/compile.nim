from process import tryRunCmd
import emitter
import logging/log
import opcode
import operation
import std/strformat
import std/options
import std/os

let dumpFilePath: string = getCurrentDir() / "csources" / "dump.c"

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
    of OP_DUP:
      output.emit("pop %rax")
      output.emit("push %rax")
      output.emit("push %rax")
    of OP_POP:
      output.emit("pop %rax")
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
    of OP_GT:
      output.emit("pop %rbx")
      output.emit("pop %rax")
      output.emit("cmp %rbx, %rax")
      output.emit("setg %al")
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
    of OP_WHILE:
      output.emit("# nothing")
    of OP_DO:
      output.emit("pop %rax")
      output.emit("cmp $0, %rax")
      output.emit(fmt"je .porth_addr_{op.doTarget.get}")
    of OP_END:
      output.emit(fmt"jmp .porth_addr_{op.endTarget.get}")

  output.dedent()
  output.emit("")
  output.emit(fmt".porth_addr_{program.len}:")
  output.indent()
  output.emit("# -- end of program --")
  output.emit("mov $0, %rax")
  output.emit("ret")
  output.close()

  tryRunCmd("gcc", ["-o", outFilePath, asmFilePath, dumpFilePath])
