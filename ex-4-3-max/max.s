  .syntax unified
  .cpu cortex-m4
  .thumb
  .global  Main

Main:

  @ Calculate the maximum of two values a and b
  @ a is in R1, b is in R2

  @ *** your solution goes here ***

  CMP   R1, R2      @ if (a >= b)
  BLE   ElseMaxB    @ {
  MOV   R0, R1      @   result = a
  B    EndMax      @ }

 ElseMaxB:          @ else {
  MOV   R0, R2      @   result = b
 EndMax:            @ }    

  @ End of program ... check your result

End_Main:
  BX    lr

.end