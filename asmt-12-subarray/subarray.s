  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb
  .global  Main

Main:

  @
  @ write your program here
  @


  SUB   R4, R1, R3                  @ int aLim = countA - countB;
  LDR   R5, = 0                     @ boolean isSub = false;

  @ countA and countB are the number of columns/rows in the respective arrays
  
  CMP   R1, #0
  BEQ   EndFor                      @ this is checking whether the arrays are empty
  CMP   R3, #0                      @ if they are the program terminates with isSub = false
  BEQ   EndFor

  LDR   R6, = 0     
For:                                @ for (int rA = 0; rA <= aLim && !isSub; rA++)
  CMP   R6, R4                      @ {
  BHI   EndFor                      
  CMP   R5, #0                      @   rA is the current row in arrayA the program is in 
  BNE   EndFor                      

  LDR   R7, = 0                     
For1:                               @   for (int cA = 0; cA <= aLim && !isSub; cA++)
  CMP   R7, R4                      @   {
  BHI   EndFor1     
  CMP   R5, #0                      @     cA is the current column in arrayA the program is in
  BNE   EndFor1     

  LDR   R5, = 1                     @     isSub = true;
  LDR   R8, = 0                     
For2:                               @     for (int rB = 0; rB < countB && isSub; rB++)
  CMP   R8, R3                      @     {
  BHS   EndFor2     
  CMP   R5, #1                      @       rB is the current row in arrayB the program is in
  BNE   EndFor2     

  LDR   R9, = 0     
For3:                               @       for (int cB = 0; cB < countB && isSub; cB++)
  CMP   R9, R3                      @       {
  BHS   EndFor3     
  CMP   R5, #1                      @         cB is the current column in arrayB the program is in
  BNE   EndFor3     

  MUL   R10, R8, R3                 @         int index = rB * countB;
  ADD   R10, R10, R9                @         index = index + cB;
  LDR   R11, [R2, R10, LSL #2]      @         int elemB = B[rB][cB];  (or elemB = B[index])
  
  ADD   R10, R6, R8                 @         index = rA + rB;
  MUL   R10, R10, R1                @         index = index * countA;
  ADD   R10, R10, R7                @         index = index + cA;
  ADD   R10, R10, R9                @         index = index + cB;
  LDR   R12, [R0, R10, LSL #2]      @         int elemA = A[rA+rB][cA+cB]; (or elemA = A[index])
  
  CMP   R12, R11                    @         if (elemA != elemB)
  BEQ   Else                        @         {
  LDR   R5, = 0                     @           isSub = false;
                                    @         }
Else:  
  ADD   R9, R9, #1
  B     For3                        @       }

EndFor3:
  ADD   R8, R8, #1
  B     For2                        @     }

EndFor2:  
  ADD   R7, R7, #1
  B     For1                        @   }
  
EndFor1:  
  ADD   R6, R6, #1
  B     For                         @ }

EndFor:   
  MOV   R0, R5                      @ this is just putting the result for isSub into R0

  
  @ End of program ... check your result

End_Main:
  BX    lr

