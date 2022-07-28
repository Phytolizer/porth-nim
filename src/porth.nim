from porthpkg/compile import compileProgram
from porthpkg/crossReference import crossReferenceBlocks
from porthpkg/debug import nil
from porthpkg/load import loadProgramFromFile
from porthpkg/process import tryRunCmd
from std/os import absolutePath
import argparse
import porthpkg/logging/log
import porthpkg/parseError
import porthpkg/processError
import porthpkg/record
import porthpkg/simulate
import std/streams

let p = newParser:
  flag("-g", "--debug", help="Enable debug mode")
  command("sim"):
    help("Simulate the program")
    arg("input", help="File to process")
  command("com"):
    help("Compile the program")
    option("-o", "--output", help="Output file")
    flag("-r", "--run", help="Run the compiled program")
    arg("input", help="File to process")
  command("record"):
    help("Record expected output for test cases")

proc run*(
  args: seq[string],
  output: Stream = newFileStream(stdout),
  silent: bool = false
) =
  log.silent = silent
  try:
    let opts = p.parse(args)
    if opts.debug:
      logInfo("Debug mode enabled")
      debug.debugging = true
    case opts.argparse_command
    of "sim":
      try:
        let sim = opts.sim.get
        let program = loadProgramFromFile(sim.input).crossReferenceBlocks()
        simulateProgram(program, output=output)
      except ParseError as e:
        logError($e)
        quit(1)
      except SimulationError:
        logError(getCurrentExceptionMsg())
        quit(1)
    of "com":
      let com = opts.com.get
      let outputParam = com.output_opt.get(com.input.changeFileExt(""))
      try:
        let program = loadProgramFromFile(com.input).crossReferenceBlocks()
        compileProgram(program, outputParam)
      except ParseError as e:
        logError($e)
        quit(1)
      if com.run:
        try:
          tryRunCmd(outputParam.absolutePath(), output=output)
        except ProcessError as e:
          logError(e.msg)
          quit(e.code)
    of "record":
      recordTestOutput()
    else:
      discard
  except UsageError:
    logError(getCurrentExceptionMsg())
    quit(1)

when isMainModule:
  run(commandLineParams())
