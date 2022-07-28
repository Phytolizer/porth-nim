type OpCode* = enum
  OP_PUSH
  OP_DUP
  OP_2DUP
  OP_DROP
  OP_SWAP
  OP_MEM
  OP_LOAD
  OP_STORE
  OP_SYSCALL1
  OP_SYSCALL2
  OP_SYSCALL3
  OP_SYSCALL4
  OP_SYSCALL5
  OP_SYSCALL6
  OP_PLUS
  OP_MINUS
  OP_EQUAL
  OP_GT
  OP_LT
  OP_SHR
  OP_SHL
  OP_BOR
  OP_BAND
  OP_DUMP
  OP_IF
  OP_ELSE
  OP_WHILE
  OP_DO
  OP_END
