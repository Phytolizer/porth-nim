# This is just an example to get you started. A typical hybrid package
# uses this file as the main entry point of the application.

from porthpkg/compile import compileProgram
from porthpkg/operation import push, plus, minus, dump
from porthpkg/process import tryRunCmd
from porthpkg/simulate import simulateProgram
from std/os import absolutePath
import argparse

const PROGRAM = @[
    push(34),
    push(35),
    plus(),
    dump(),
    push(500),
    push(80),
    minus(),
    dump(),
]

when isMainModule:
    var p = newParser:
        command("sim"):
            help("Simulate the program")
            run:
                simulateProgram(PROGRAM)
        command("com"):
            help("Compile the program")
            option("-o", "--output", help="Output file")
            flag("-r", "--run", help="Run the compiled program")
            run:
                let output = opts.output_opt.get("output")
                compileProgram(PROGRAM, output)
                if opts.run:
                    tryRunCmd(output.absolutePath())

    try:
        p.run(commandLineParams())
    except UsageError:
        stderr.writeLine getCurrentExceptionMsg()
        quit(1)
