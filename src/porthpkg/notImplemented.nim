type NotImplementedDefect* = object of Defect

proc newNotImplementedDefect*: ref NotImplementedDefect =
  newException(NotImplementedDefect, "not implemented")
