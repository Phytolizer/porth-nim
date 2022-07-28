type ProcessError* = object of OSError
  code*: int

proc newProcessError*(code: int, msg: string): ref ProcessError =
  result = newException(ProcessError, msg)
  result.code = code
