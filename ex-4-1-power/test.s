  .syntax unified
  .cpu cortex-m4
  .thumb

  .global  Init_Test

  .section  .text

  .type     Init_Test, %function
Init_Test:
  @ Test with x=8, y=9
  MOV   R1, #8
  MOV   R2, #9
  bx    lr

.end