  .syntax unified
  .cpu cortex-m4
  .thumb
  .global  Main

Main:

  CMP   R1, #10                         @ if (v < 10) {
  BHS   GreaterThanOrEqualsTen          @ 	a = 1;
  MOV   R0, 1                           @ }
  B     EndIf                           @ else if (v < 100) {
  
  GreaterThanOrEqualsTen:               @   a = 10
  CMP   R1, #100                        @ }
  BHS   GreaterThanOrEqualsOneHundred   @ else if (v < 1000) {
  MOV   R0, #10                         @ a = 100;
  B     EndIf                           @ }
  
  GreaterThanOrEqualsOneHundred:        @ else {
  CMP   R1, #1000                       @ 	a = 0;
  BHS   GreaterThanOrEqualsOneThousand
  MOV   R0, #100                        @ }  
  B     EndIf

  GreaterThanOrEqualsOneThousand:
  MOV   R0, 0

  EndIf:
  @ *** your solution goes here ***

  @ End of program ... check your result

End_Main:
  BX    lr

.end