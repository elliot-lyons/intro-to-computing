  .syntax unified
  .cpu cortex-m4
  .thumb
  .global  Init_Test

  .section  .text

  .type     Init_Test, %function
Init_Test:
  @ Initialise registers with your test vlues here

  LDR   R1, =73

  @ Do not edit below this line
  bx    lr

.end

@ Hello Elliot!
