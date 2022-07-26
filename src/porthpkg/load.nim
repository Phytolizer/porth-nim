from operation import Operation
from lex import lexFile
from parse import parseTokenAsOp
from std/sequtils import map

proc loadProgramFromFile*(path: string): seq[Operation] =
  lexFile(path).map(parseTokenAsOp)
