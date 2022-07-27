import nimcx
import std/strformat

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
  let fg = getFg(LOG_LEVEL_COLORS[level])
  stdout.write "["
  cxprint.print(tag, fgr=fg)
  echo fmt"] {msg}"

proc info*(msg: string) =
  log(LogLevel.Info, "INFO", msg)

proc cmd*(msg: string) =
  log(LogLevel.Cmd, "CMD", msg)

proc error*(msg: string) =
  log(LogLevel.Error, "ERROR", msg)
