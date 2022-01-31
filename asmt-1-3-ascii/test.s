  .syntax unified
  .cpu cortex-m4
  .thumb

  .global  Init_Test

  .section  .text

  .type     Init_Test, %function
Init_Test:
  @ Evaluate for 2034 (0x7F2)
  LDR   R1, =0x39   @ '9'
  LDR   R2, =0x37   @ '7'
  LDR   R3, =0x31   @ '1'
  LDR   R4, =0x33   @ '3'

  @ Alternatively, you can initialise this way ...
  @ LDR   R1, ='9'
  @ LDR   R2, ='7'
  @ LDR   R3, ='1'
  @ LDR   R4, ='3'

  bx    lr

.end