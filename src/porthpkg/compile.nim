from process import tryRunCmd
import emitter
import logging/log
import mem
import opcode
import operation
import processError
import std/strformat
import std/options
import std/os

let dumpFilePath: string = getCurrentDir() / "csources" / "dump.c"

proc compileProgram*(program: seq[Operation], outFilePath: string) =
  let asmFilePath = outFilePath.changeFileExt("s")
  logInfo(fmt"Generating {asmFilePath}")
  var output = newEmitter(open(asmFilePath, fmWrite))

  output.indent()
  output.emit(".global _start")
  output.emit(".text")
  output.dedent()
  output.emit("_start:")
  output.indent()

  for ip in 0..<program.len:
    let op = program[ip]
    output.dedent()
    output.emit(fmt".porth_addr_{ip}:")
    output.indent()
    output.emit(fmt"# -- {op} --")
    case op.code
    of OP_PUSH:
      output.emit(fmt"pushq ${op.pushValue}")
    of OP_DUP:
      output.emit("popq %rax")
      output.emit("pushq %rax")
      output.emit("pushq %rax")
    of OP_POP:
      output.emit("popq %rax")
    of OP_MEM:
      output.emit("leaq porth_memory(%rip), %rax")
      output.emit("pushq %rax")
    of OP_LOAD:
      output.emit("popq %rbx")
      output.emit("movzbq (%rbx), %rax")
      output.emit("pushq %rax")
    of OP_STORE:
      output.emit("popq %rax")
      output.emit("popq %rbx")
      output.emit("movq %rax, (%rbx)")
    of OP_SYSCALL1:
      output.emit("popq %rax")
      output.emit("popq %rdi")
      output.emit("syscall")
    of OP_SYSCALL2:
      output.emit("popq %rax")
      output.emit("popq %rdi")
      output.emit("popq %rsi")
      output.emit("syscall")
    of OP_SYSCALL3:
      output.emit("popq %rax")
      output.emit("popq %rdi")
      output.emit("popq %rsi")
      output.emit("popq %rdx")
      output.emit("syscall")
    of OP_SYSCALL4:
      output.emit("popq %rax")
      output.emit("popq %rdi")
      output.emit("popq %rsi")
      output.emit("popq %rdx")
      output.emit("popq %r10")
      output.emit("syscall")
    of OP_SYSCALL5:
      output.emit("popq %rax")
      output.emit("popq %rdi")
      output.emit("popq %rsi")
      output.emit("popq %rdx")
      output.emit("popq %r10")
      output.emit("popq %r8")
      output.emit("syscall")
    of OP_SYSCALL6:
      output.emit("popq %rax")
      output.emit("popq %rdi")
      output.emit("popq %rsi")
      output.emit("popq %rdx")
      output.emit("popq %r10")
      output.emit("popq %r8")
      output.emit("popq %r9")
      output.emit("syscall")
    of OP_PLUS:
      output.emit("popq %rbx")
      output.emit("popq %rax")
      output.emit("addq %rbx, %rax")
      output.emit("pushq %rax")
    of OP_MINUS:
      output.emit("popq %rbx")
      output.emit("popq %rax")
      output.emit("subq %rbx, %rax")
      output.emit("pushq %rax")
    of OP_EQUAL:
      output.emit("popq %rbx")
      output.emit("popq %rax")
      output.emit("cmpq %rbx, %rax")
      output.emit("sete %aq")
      output.emit("movsx %aq, %rax")
      output.emit("pushq %rax")
    of OP_GT:
      output.emit("popq %rbx")
      output.emit("popq %rax")
      output.emit("cmpq %rbx, %rax")
      output.emit("setg %al")
      output.emit("movsx %al, %rax")
      output.emit("pushq %rax")
    of OP_DUMP:
      output.emit("popq %rdi")
      output.emit("call porth_dump")
    of OP_IF:
      output.emit("popq %rax")
      output.emit("cmpq $0, %rax")
      output.emit(fmt"je .porth_addr_{op.ifTarget.get}")
    of OP_ELSE:
      output.emit(fmt"jmp .porth_addr_{op.elseTarget.get}")
    of OP_WHILE:
      output.emit("# nothing")
    of OP_DO:
      output.emit("popq %rax")
      output.emit("cmpq $0, %rax")
      output.emit(fmt"je .porth_addr_{op.doTarget.get}")
    of OP_END:
      output.emit(fmt"jmp .porth_addr_{op.endTarget.get}")

  output.dedent()
  output.emit("")
  output.emit(fmt".porth_addr_{program.len}:")
  output.indent()
  output.emit("# -- end of program --")
  output.emit("movq $60, %rax")
  output.emit("movq $0, %rdi")
  output.emit("syscall")
  output.emit(".data")
  output.dedent()
  output.emit("porth_memory:")
  output.indent()
  output.emit(fmt".zero {MEM_CAPACITY}")
  output.close()

  try:
    tryRunCmd("gcc", ["-nostdlib", "-O2", "-o", outFilePath, asmFilePath, dumpFilePath, "-lc"])
  except ProcessError as e:
    logError(e.msg)
    quit(e.code)
