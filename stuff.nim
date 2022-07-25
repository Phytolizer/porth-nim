import argparse

var p = newParser:
  flag("-a", "--apple")
  flag("-b", help="Show a banana")
  option("-o", "--output", help="Output to this file")
  command("somecommand"):
    arg("name")
    arg("others", nargs = -1)
    run:
      echo opts.name
      echo opts.others
      echo opts.parentOpts.apple
      echo opts.parentOpts.b
      echo opts.parentOpts.output
      echo opts.parentOpts.output_opt.get()

try:
  p.run(@["--apple", "-o=foo", "somecommand", "myname", "thing1", "thing2"])
except UsageError as e:
  stderr.writeLine getCurrentExceptionMsg()
  quit(1)
