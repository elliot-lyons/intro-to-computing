  .syntax unified
  .cpu cortex-m4
  .thumb
  .global  Main

Main:

  @ Compute absolute value of value in R1

  MOV   R0, R1          @ result = value
  CMP   R0, #0          @ if (result < 0)
  BGE   EndIfNeg        @ {
  RSB   R0, R0, #0      @   result = 0 - result
  EndIfNeg:             @ }

  @ End of program ... check your result

End_Main:
  BX    lr

.end