from std/osproc import
    startProcess,
    poParentStreams,
    poUsePath,
    waitForExit
from processError import ProcessError
from std/strutils import join
import std/strformat

proc tryRunCmd*(cmd: string, args: openArray[string] = []) =
    let process = startProcess(cmd, args=args, options={poParentStreams, poUsePath})
    let code = process.waitForExit()
    if code != 0:
        raise newException(ProcessError, fmt"{cmd} {args.join("" "")} failed with code {code}")
