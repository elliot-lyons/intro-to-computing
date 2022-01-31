  .syntax unified
  .cpu cortex-m4
  .thumb
  .global  Main

Main:

  @
  @ Write a program to swap the middle two bytes of the value in
  @   R4, leaving the outer two bytes unchanged
  @
  @ For example, if R4 initially contains 0x89ABCDEF, your program
  @   should change R4 to 0x89CDABEF
  @

  LDR   R5, =0x00FF0000
  AND   R5, R4, R5
  MOV   R5, R5, LSR #8

  LDR   R6, =0x0000FF00
  AND   R6, R4, R6
  MOV   R6, R6, LSL #8

  LDR   R7, =0x00FFFF00
  BIC   R4, R4, R7
  ORR   R4, R4, R5
  ORR   R4, R4, R6

  @ *** your solution goes here ***

  @ End of program ... check your result

End_Main:
  BX    lr

.end