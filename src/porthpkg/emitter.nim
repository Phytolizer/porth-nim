from std/strutils import repeat

type Emitter* = object
  inner: File
  indentLevel: int
  indent: string

proc newEmitter*(inner: File): Emitter =
  result.inner = inner
  result.indentLevel = 0
  result.indent = ""

proc updateIndent(emitter: var Emitter) =
  emitter.indent = repeat(' ', emitter.indentLevel * 4)

proc indent*(emitter: var Emitter) =
  emitter.indentLevel += 1
  emitter.updateIndent()

proc dedent*(emitter: var Emitter) =
  emitter.indentLevel -= 1
  emitter.updateIndent()

proc emit*(emitter: Emitter, text: string) =
  emitter.inner.writeLine(emitter.indent & text)

proc close*(emitter: Emitter) =
  emitter.inner.close()
