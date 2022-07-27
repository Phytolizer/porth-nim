from porth import run
import porthpkg/logging/log
import std/os
import std/sequtils
import std/streams
import std/strutils
import std/unittest

test "output is similar":
  for testFile in walkDirRec("testCases")
      .toSeq()
      .filter(proc(name: string): bool = name.splitFile().ext == ".porth"):
    var output = newStringStream("")
    run(@["sim", testFile], output=output)
    output.setPosition(0)
    let simOutput = output.readAll()
    output.setPosition(0)
    run(@["com", "-r", testFile], output=output)
    output.setPosition(0)
    let comOutput = output.readAll()
    if simOutput != comOutput:
      logError("Output discrepancy between simulation and compilation")
      echo "  Simulation output:"
      echo simOutput.indent(4)
      echo "  Compilation output:"
      echo comOutput.indent(4)
      assert false, "Output discrepancy between simulation and compilation"
