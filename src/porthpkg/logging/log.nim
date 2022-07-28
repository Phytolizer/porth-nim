import nimcx
import std/strformat

var silent* = false

type LogLevel {.pure.} = enum
  Info
  Cmd
  Error

const LOG_LEVEL_COLORS = [
  LogLevel.Info: fgGreen,
  LogLevel.Cmd: fgBlue,
  LogLevel.Error: fgRed,
]

proc log(level: LogLevel, tag: string, msg: string) =
  if silent:
    return
  let fg = getFg(LOG_LEVEL_COLORS[level])
  stdout.write "["
  cxprint.print(tag, fgr=fg)
  echo fmt"] {msg}"

proc logInfo*(msg: string) =
  log(LogLevel.Info, "INFO", msg)

proc logCmd*(msg: string) =
  log(LogLevel.Cmd, "CMD", msg)

proc logError*(msg: string) =
  log(LogLevel.Error, "ERROR", msg)
