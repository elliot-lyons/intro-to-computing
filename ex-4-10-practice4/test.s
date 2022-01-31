  .syntax unified
  .cpu cortex-m4
  .thumb

  .global  Init_Test

  .section  .text

  .type     Init_Test, %function
Init_Test:
  @ Test with upper case character 'J'
  MOV   R0, #'J'
  bx    lr

.end