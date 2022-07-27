from porthpkg/compile import compileProgram
from porthpkg/crossReference import crossReferenceBlocks
from porthpkg/load import loadProgramFromFile
from porthpkg/process import tryRunCmd
from porthpkg/simulate import simulateProgram
from std/os import absolutePath
import argparse
import porthpkg/logging/log
import porthpkg/parseError

when isMainModule:
  var p = newParser:
    command("sim"):
      help("Simulate the program")
      arg("input", help="File to process")
      run:
        try:
          let program = loadProgramFromFile(opts.input).crossReferenceBlocks()
          simulateProgram(program)
        except ParseError as e:
          logError($e)
          quit(1)
    command("com"):
      help("Compile the program")
      option("-o", "--output", help="Output file")
      flag("-r", "--run", help="Run the compiled program")
      arg("input", help="File to process")
      run:
        let output = opts.output_opt.get("output")
        try:
          let program = loadProgramFromFile(opts.input).crossReferenceBlocks()
          compileProgram(program, output)
        except ParseError as e:
          logError($e)
          quit(1)
        if opts.run:
          tryRunCmd(output.absolutePath())

  try:
    p.run(commandLineParams())
  except UsageError:
    logError(getCurrentExceptionMsg())
    quit(1)
