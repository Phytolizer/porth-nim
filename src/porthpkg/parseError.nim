from token import Token
import std/strformat

type ParseError* = object of CatchableError
  token: Token

proc newParseError*(token: Token, msg: string): ref ParseError =
  result = newException(ParseError, msg)
  result.token = token

proc `$`*(e: ref ParseError): string =
  fmt"{e.token.filePath}:{e.token.line}:{e.token.column}: {e.msg}"
