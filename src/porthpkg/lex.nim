from token import Token
from std/strutils import splitLines
from std/re import re, find

let nonSpacePattern = re"\S"
let spacePattern = re"\s"

proc lexLine(filePath: string, lineNumber: int, line: string): seq[Token] =
  var col = line.find(nonSpacePattern)
  while col < line.len and col != -1:
    var colEnd = line.find(spacePattern, col)
    if colEnd == -1:
      colEnd = line.len
    let text = line[col..<colEnd]
    if text == "//":
      break
    result.add(Token(
      filePath: filePath,
      line: lineNumber + 1,
      column: col + 1,
      text: text,
    ))
    col = line.find(nonSpacePattern, colEnd)

proc lexFile*(filePath: string): seq[Token] =
  var f = open(filePath, fmRead)
  defer: f.close()

  for lineNumber, line in f.readAll().splitLines().pairs():
    result.add(lexLine(filePath, lineNumber, line))
