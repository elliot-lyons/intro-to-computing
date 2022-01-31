  .syntax unified
  .cpu cortex-m4
  .thumb
  .global  Main

Main:

 WhileGreaterOrEqualThanThirteen:     @ while (h >= 13) {
  CMP   R0, #13                       @ 	h = h - 12;
  BLT   LessThanThirteen              @ }
  SUB   R0, R0, #12
  B     WhileGreaterOrEqualThanThirteen

 LessThanThirteen: 
  @ *** your solution goes here ***

  @ End of program ... check your result

End_Main:
  BX    lr

.end