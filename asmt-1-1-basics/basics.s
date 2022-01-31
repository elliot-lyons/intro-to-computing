  .syntax unified
  .cpu cortex-m4
  .thumb
  .global  Main

Main:

  @ Write an ARM Assembly Language program to evaluate
  @   x^3 - 4x^2 + 3x + 8

  @ *** your solution goes here ***

  LDR   R0, =0        @ result = 0
  MUL   R0, R1, R1    @ x^2
  MUL   R0, R0, R1    @ x^3

  LDR   R2, =4
  MUL   R3, R1, R1    @ x^2
  MUL   R2, R2, R3    @ 4x^2

  SUB   R0, R0, R2    @ x^3 - 4x^2

  LDR   R2, =3
  MUL   R2, R2, R1    @ 3x

  ADD   R0, R0, R2    @ x^3 - 4x^2 + 3x

  ADD   R0, R0, #8    @ x^3 - 4x^2 + 3x + 8

  @ End of program ... check your result

End_Main:
  BX    lr

.end
