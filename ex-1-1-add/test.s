  .syntax unified
  .cpu cortex-m4
  .thumb
  .global  Init_Test

  .section  .text

  .type     Init_Test, %function
Init_Test:
  @ Set up a, b, c and d with some test values
  MOV   R1, #1          @ a=6
  MOV   R2, #2          @ b=7
  MOV   R3, #3          @ c=8
  MOV   R4, #4          @ d=9
  bx    lr

.end

@ Hello Elliot and Kevin!
