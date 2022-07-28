import crossReference
import load
import simulate
import std/os
import std/streams

proc recordTestOutput* =
  for testFile in walkDirRec(getCurrentDir() / "testCases"):
    if testFile.splitFile().ext == ".porth":
      let output = newFileStream(testFile.changeFileExt(".output.txt"), fmWrite)
      let program = loadProgramFromFile(testFile).crossReferenceBlocks()
      simulateProgram(program, output=output)
