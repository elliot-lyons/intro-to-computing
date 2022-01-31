  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb
  .global  Main

Main:

  @
  @ write your program here
  @

  @
  @ TIP: To view memory when debugging your program you can ...
  @
  @   Add the following watch expression: (unsigned char [64]) stringB
  @
  @   OR
  @
  @   Open a Memory View specifying the address 0x20000000 and length at least 11
  @   You can open a Memory View with ctrl-shift-p type view memory (cmd-shift-p on a Mac)

Main: 
  MOV   R3, R1

WhileSrch:
  LDRB    R2, [R3] 
  CMP     R2, #0
  BEQ     EndWhSrch

  ADD     R0, R0, #1

  ADD     R3, R3, #1
  B       WhileSrch

EndWhSrch:

  MOV     R2, #0
  STRB    R2, [R0]


While:
  LDRB   R2, [R1]
  CMP   R2, 0x00
  BEQ   EndWh
  
  SUB   R0, R0, #1
  STRB  R2, [R0]

  ADD   R1, R1, #1
  B     While
EndWh:

  @

  @ End of program ... check your result

End_Main:
  BX    lr

