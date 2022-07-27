from porthpkg/compile import compileProgram
from porthpkg/crossReference import crossReferenceBlocks
from porthpkg/load import loadProgramFromFile
from porthpkg/process import tryRunCmd
from porthpkg/simulate import simulateProgram
from std/os import absolutePath
import argparse
import porthpkg/logging/log
import porthpkg/parseError
import std/streams

let p = newParser:
  command("sim"):
    help("Simulate the program")
    arg("input", help="File to process")
  command("com"):
    help("Compile the program")
    option("-o", "--output", help="Output file")
    flag("-r", "--run", help="Run the compiled program")
    arg("input", help="File to process")

proc run*(args: seq[string], output: Stream = newFileStream(stdout)) =
  try:
    let opts = p.parse(args)
    case opts.argparse_command
    of "sim":
      try:
        let sim = opts.sim.get
        let program = loadProgramFromFile(sim.input).crossReferenceBlocks()
        simulateProgram(program, output=output)
      except ParseError as e:
        logError($e)
        quit(1)
    of "com":
      let com = opts.com.get
      let outputParam = com.output_opt.get("output")
      try:
        let program = loadProgramFromFile(com.input).crossReferenceBlocks()
        compileProgram(program, outputParam)
      except ParseError as e:
        logError($e)
        quit(1)
      if com.run:
        tryRunCmd(outputParam.absolutePath(), output=output)
    else:
      discard
  except UsageError:
    logError(getCurrentExceptionMsg())
    quit(1)

when isMainModule:
  run(commandLineParams())
