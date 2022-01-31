  .syntax unified
  .cpu cortex-m4
  .thumb
  .global  Main

Main:

  @ if (ch=='a' || ch=='e' || ch=='i' || ch=='o' || ch=='u')
  @ {
  @ 	v = 1;
  @ }
  @ else {
  @ 	v = 0;
  @ }

  @ *** your solution goes here ***

  CMP     R1, #'a'
  BEQ     IfVowel
  CMP     R1, #'e'
  BEQ     IfVowel
  CMP     R1, #'i'
  BEQ     IfVowel
  CMP     R1, #'o'
  BEQ     IfVowel
  CMP     R1, #'u'
  BEQ     IfVowel
  B       ElseNotVowel 

IfVowel:  
  MOV     R0, #1
  B       EndIfVowel

ElseNotVowel:
  MOV     R0, #0

EndIfVowel:


  @ End of program ... check your result

End_Main:
  BX    lr

.end