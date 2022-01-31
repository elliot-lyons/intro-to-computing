  .syntax unified
  .cpu cortex-m4
  .thumb

  .global  Init_Test

  .section  .text

  .type     Init_Test, %function
Init_Test:
  @ Test with lower case character 'g'
  MOV   R0, #'g'
  bx    lr

.end