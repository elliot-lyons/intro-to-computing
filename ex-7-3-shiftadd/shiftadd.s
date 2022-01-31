  .syntax unified
  .cpu cortex-m4
  .thumb
  .global  Main

Main:

  @
  @ Write a program to multiply R1 by R2 using the
  @   shift-and-add technique from the lectures.
  @   Store the result in R0.
  @
  @

  @ *** your solution goes here ***



  LDR   R0, =0     @ result = 0;
  LDR   R3, =31    @ count = 31;
  MOV   R4, R2     @ test = a;
  LDR   R5, = 0    @ temp = 0;

While:
  CMP   R3, #0              @ while ( count >= 0 )
  BLT   EndWh
  MOVS  R4, R4, LSL #1      @ { test = test << 1;
  BCC   Clear               @   if ( carry flag set )
  MOV   R5, R1, LSL R3      @   { temp = a << count;
  ADD   R0, R0, R5          @     result = result + temp; } 
Clear:
  SUB   R3, R3, #1          @    count--;
  B     While               @ }

EndWh:    



  @ End of program ... check your result

End_Main:
  BX    lr

.end