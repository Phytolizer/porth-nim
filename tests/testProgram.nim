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
      var output = newStringStream("")
      run(@["sim", testFile], output=output, silent=true)
      output.setPosition(0)
      let simOutput = output.readAll()
      output.setPosition(0)
      run(@["com", "-r", testFile], output=output, silent=true)
      output.setPosition(0)
      let comOutput = output.readAll()
      if simOutput != comOutput:
        stderr.writeLine(fmt"Output discrepancy between simulation and compilation in {testFile}")
        echo "  Simulation output:"
        echo simOutput.indent(4)
        echo "  Compilation output:"
        echo comOutput.indent(4)
        assert false, "Output discrepancy between simulation and compilation"
