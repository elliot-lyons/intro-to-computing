  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb

  .global Init_Test
  .global setA
  .global setB
  .global setC


  .section  .text

  .type     Init_Test, %function
Init_Test:
  @ Set R1 to the start address of the test string
  LDR   R1, =setA   @ address of set AB
  LDR   R2, =setB   @ address of set B
  LDR   R0, =setC   @ address to store set C
  BX    LR


  .section  .rodata

setA:
  .word  2                                       @ size A
  .word  4, 5   @ elems A

setB:
  .word  3                                        @ size B
  .word  4, 5, 6             @ elems B


  .section  .data

setC:
  .space    4                                     @ size C
  .space    64                                    @ elems C

.end