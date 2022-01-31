  .syntax unified
  .cpu cortex-m4
  .thumb
  .global  Main

Main:

  @ Write an ARM Assembly Language program to evaluate
  @   ax^2 + bx + c for given values of a, b, c and x

  @ *** your solution goes here ***

  LDR   R0, =0        @ result = 0

  MUL   R0, R1, R1    @ x^2
  MUL   R0, R0, R2    @ ax^2

  MUL   R2, R1, R3    @ bx

  ADD   R0, R0, R2    @ ax^2 + bx

  ADD   R0, R0, R4    @ax^2 + bx + c

  @ End of program ... check your result

End_Main:
  BX    lr

.end
