from operation import Operation
from parse import parseTokenAsOp
from std/strutils import splitWhitespace

iterator loadProgramFromFile*(path: string): Operation =
    var f = open(path, fmRead)
    defer: f.close()

    for token in f.readAll().splitWhitespace():
        yield parseTokenAsOp(token)

proc loadProgramFromFile*(path: string): seq[Operation] =
    for op in loadProgramFromFile(path):
        result.add(op)
