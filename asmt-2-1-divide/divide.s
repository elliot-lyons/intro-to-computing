  .syntax unified
  .cpu cortex-m4
  .thumb
  .global  Main

Main:

  @ Write an ARM Assembly Language Program that will divide a
  @   value, a, in R2 by another value, b, in R3.
  
  @ *** your solution goes here ***

  MOV   R0, #0              @ if (b=0)
  CMP   R3, #0              @ result = 0 
  BEQ   EndWh                 @ result = 0;
While:                      @ while a >= b 
  CMP   R2, R3              @ {
  BLT   EndWh               @   a = a - b;
  SUB   R2, R2, R3          @   result = result + 1; 
  ADD   R0, R0, #1          @ }
  B     While               @ result = result;
EndWh:                      @ remainder = a;  
  MOV   R1, R2
  
       

    
  @ End of program ... check your result

End_Main:
  BX    lr

.end
