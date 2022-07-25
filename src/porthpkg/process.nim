from std/osproc import execCmd
from processError import ProcessError
import std/strformat

proc tryRunCmd*(cmd: string) =
    let code = execCmd(cmd)
    if code != 0:
        raise newException(ProcessError, fmt"{cmd} failed with code {code}")
