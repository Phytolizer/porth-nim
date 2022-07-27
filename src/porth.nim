from porthpkg/compile import compileProgram
from porthpkg/crossReference import crossReferenceBlocks
from porthpkg/load import loadProgramFromFile
from porthpkg/logger/logger import nil
from porthpkg/process import tryRunCmd
from porthpkg/simulate import simulateProgram
from std/os import absolutePath
import argparse

when isMainModule:
  var p = newParser:
    command("sim"):
      help("Simulate the program")
      arg("input", help="File to process")
      run:
        let program = loadProgramFromFile(opts.input).crossReferenceBlocks()
        simulateProgram(program)
    command("com"):
      help("Compile the program")
      option("-o", "--output", help="Output file")
      flag("-r", "--run", help="Run the compiled program")
      arg("input", help="File to process")
      run:
        let output = opts.output_opt.get("output")
        let program = loadProgramFromFile(opts.input).crossReferenceBlocks()
        compileProgram(program, output)
        if opts.run:
          tryRunCmd(output.absolutePath())

  try:
    p.run(commandLineParams())
  except UsageError:
    logger.error(getCurrentExceptionMsg())
    quit(1)
