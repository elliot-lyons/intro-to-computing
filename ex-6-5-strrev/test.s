  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb

  .global Init_Test
  .global stringA
  .global stringB

  .section  .text

  .type     Init_Test, %function
Init_Test:
  @ Set R1 to the start address of the test string
  LDR   R0, =stringB
  LDR   R1, =stringA
  BX    LR


  .section  .rodata

stringA:
  .asciz  "Do not test with a palindrome"


  .section  .data

stringB:
  .space  256


.end