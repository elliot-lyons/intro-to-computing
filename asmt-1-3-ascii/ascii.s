  .syntax unified
  .cpu cortex-m4
  .thumb
  .global  Main

Main:

  @ Write an ARM Assembly Language Program that will convert
  @    a sequence of four ASCII characters, each representing a
  @    decimal digit, into tje to the value represented by the
  @    sequence.
  
  @ e.g. '2', '0', '3', '4' (or 0x32, 0x30, 0x33, 0x34) to 2034 (0x7F2)

  @ *** your solution goes here ***

  
  SUB   R1, R1, 0x30      @ 'R1' = R1
  SUB   R2, R2, 0x30      @ 'R2' = R2
  SUB   R3, R3, 0x30      @ 'R3' = R3
  SUB   R4, R4, 0x30      @ 'R4' = R4

  LDR   R0, =0            @ result = 0
  LDR   R5, =10

  ADD   R0, R0, R4        @ result = R4
  MUL   R0, R0, R5        @ result = result * 10

  ADD   R0, R0, R3        @ result = R4 R3
  MUL   R0, R0, R5

  ADD   R0, R0, R2        @ result = R4 R3 R2
  MUL   R0, R0, R5

  ADD   R0, R0, R1        @ result = R4 R3 R2 R1


  @ End of program ... check your result

End_Main:
  BX    lr

.end
