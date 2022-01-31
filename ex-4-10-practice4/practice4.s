  .syntax unified
  .cpu cortex-m4
  .thumb
  .global  Main

Main:

  CMP   R0, #'A'          @ if (ch >= 'A' && ch <= 'Z') {
  BLT   EndIf             @ 	ch = ch + 0x20;
  CMP   R0, #'Z'          @ }
  BGT   EndIf
  ADD   R0, R0, #0x20

EndIf:  
    @ *** your solution goes here ***

  @ End of program ... check your result

End_Main:
  BX    lr

.end