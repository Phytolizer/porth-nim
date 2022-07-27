from processError import ProcessError
from std/strutils import join
import logging/log
import std/osproc
import std/streams
import std/strformat

proc tryRunCmd*(cmd: string, args: openArray[string] = [], output: Stream = newFileStream(stdout)) =
  let prettyArgs = args.join(" ")
  logCmd(fmt"{cmd} {prettyArgs}")
  let process = startProcess(cmd, args=args, options={poStdErrToStdOut, poUsePath})
  let code = process.waitForExit()
  if code != 0:
    raise newException(ProcessError, fmt"{cmd} {prettyArgs} failed with code {code}")
  output.write(process.outputStream.readAll)
