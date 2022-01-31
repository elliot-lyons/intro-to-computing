  .syntax unified
  .cpu cortex-m4
  .thumb
  .global  Main

@
@ bubblesort exercise
@ See the Exercises discussion board on Blackboard
@

Main:

@
@ write your bubblesort program here
@

  LDR   R7, = 0
  LDR   R5, = 1
  LDRB  R3, [R2] 

While:      @ do {
  CMP   R5, #1
  BNE   End 
  LDR   R5, = 0@     swapped = false;
  LDR   R6, = 1

For:  @     for (i = 1; i < N; i++) {
  CMP   R6, R3@         if (array[i−1] > array[i]) {
  BHS   EndFor@             tmpswap = array[i−1];
  SUB   R7, R6, #1
  LDRB  R8, [R1, R7]   @             array[i−1] = array[i];
  LDRB  R9, [R1]@             array[i] = tmpswap;
  CMP   R8, R9@             swapped = true ;
  BHS   EndIf@         }
  MOV   R10, R8@     }
  STRB  R9, [R1, R7]
  STRB  R10, [R1]
  LDR   R5, = 1
  EndIf:
  ADD   R6, R6, #1
  B     For
EndFor:  
  B     While@ } while ( swapped );

End:

End_Main:
  BX      LR

  .end