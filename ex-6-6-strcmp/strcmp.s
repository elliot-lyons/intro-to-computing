  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb
  .global  Main

Main:

  @
  @ write your program here
  @

  MOV    R0, #0
  LDRB   R3, [R1]
  LDRB   R4, [R2]
  CMP    R3, #0x00
  BNE    While
  CMP    R4, 0x00
  BEQ    EndWh

While:
  LDRB   R3, [R1]
  LDRB   R4, [R2]
  CMP    R3, R4
  BEQ    Equals
  CMP    R3, R4
  BHI    R4Preceeds
  MOV    R0, #-1  
  B      EndWh
R4Preceeds:
  MOV    R0, #1
  B      EndWh
Equals:
  ADD   R1, R1, #1
  ADD   R2, R2, #1
  LDRB  R3, [R1]
  LDRB  R4, [R2]
  CMP   R3, #0x00
  BNE   While
  CMP   R4, #0x00
  BNE   While   

EndWh:

  @ End of program ... check your result

End_Main:
  BX    lr

