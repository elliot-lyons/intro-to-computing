  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb

  .global Main


  .section  .text


  .type     Main, %function
Main:
  STMFD   SP!, {LR}

  LDR     R0, =grid
  LDR     R1, =oneString
  BL      searchLR

End_Main:
  LDMFD   SP!, {PC}



  .section  .rodata

@ Grid with "compute" appearing horizontally starting at [6,3]
grid:
    .byte   'x', 'x', 'x', 'x', 'x', 'x', 'o', 'm', 'p', 'u', 't', 'e'
    .byte   'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x'
    .byte   'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x'
    .byte   'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'c', 'o'
    .byte   'm', 'p', 'u', 't', 'e', 'x', 'x', 'x', 'x', 'x', 'x', 'x'
    .byte   'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x'
    .byte   'x', 'x', 'x', 'c', 'o', 'm', 'p', 'a', 't', 'e', 'x', 'x'
    .byte   'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x'
    .byte   'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x'
    .byte   'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x'
    .byte   'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x'
    .byte   'x', 'x', 'x', 'x', 'x', 'c', 'o', 'm', 'p', 'u', 't', 'e'


oneString:
    .asciz  "compute"



  .section  .data

@
@ you can declare space here for any data you wish to store in RAM
@

.end
