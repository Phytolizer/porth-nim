from processError import ProcessError
from std/strutils import join
import logging/log
import std/osproc
import std/strformat

proc tryRunCmd*(cmd: string, args: openArray[string] = []) =
  let prettyArgs = args.join(" ")
  logCmd(fmt"{cmd} {prettyArgs}")
  let process = startProcess(cmd, args=args, options={poParentStreams, poUsePath})
  let code = process.waitForExit()
  if code != 0:
    raise newException(ProcessError, fmt"{cmd} {prettyArgs} failed with code {code}")
