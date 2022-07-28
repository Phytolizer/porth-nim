from porth import run
import std/os
import std/sequtils
import std/streams
import std/strformat
import std/strutils
import std/unittest

suite "output is similar":
  for testFile in walkDirRec("testCases")
      .toSeq()
      .filter(proc(name: string): bool = name.splitFile().ext == ".porth"):
    test testFile:
      let outputTxtPath = testFile.changeFileExt(".output.txt")
      let expectedOutput = try: open(outputTxtPath).readAll()
      except:
        assert false, fmt"Could not open {outputTxtPath}, try running 'porth record' first"
        ""
      var output = newStringStream("")
      run(@["sim", testFile], output=output, silent=true)
      output.setPosition(0)
      let simOutput = output.readAll()
      if simOutput != expectedOutput:
        stderr.writeLine(fmt"Output differs in simulation for {testFile}")
        echo "Expected output:"
        echo expectedOutput.indent(2)
        echo "Simulation output:"
        echo simOutput.indent(2)
        assert false, fmt"Output differs in simulation for {testFile}"
      output.setPosition(0)
      run(@["com", "-r", testFile], output=output, silent=true)
      output.setPosition(0)
      let comOutput = output.readAll()
      if comOutput != expectedOutput:
        stderr.writeLine(fmt"Output differs in compilation for {testFile}")
        echo "Expected output:"
        echo expectedOutput.indent(2)
        echo "Compilation output:"
        echo comOutput.indent(2)
        assert false, fmt"Output differs in compilation for {testFile}"
