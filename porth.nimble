# Package

version       = "0.1.0"
author        = "Kyle Coffey"
description   = "Porth in Nim"
license       = "MIT"
srcDir        = "src"
installExt    = @["nim"]
bin           = @["porth"]


# Dependencies

requires "nim >= 1.6.6"
requires "argparse >= 3.0.0"
requires "nimcx"
