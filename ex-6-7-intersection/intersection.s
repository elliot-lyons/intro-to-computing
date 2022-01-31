  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb
  .global  Main

Main:

  @
  @ write your program here
  @

  @ Debugging tip:
  @ Use the watch expression ...
  @
  @   (signed int [64]) setC
  @
  @ ... to view your intersection set as your program creates it
  @ in memory.


  MOV   R7, #0          @ iA = 0;
While:                  @ while (iA < sizeA)
  CMP     R7, R3        @ {
  BHS     EndWh
  LDR     R5, [R1]      @   elemA = word[adrA];

  MOV     R9, R2        @   adrTmp = adrB;
  MOV     R8, #0        @   iB = 0;

While1:                 @   while (iB < sizeB)
  CMP     R8, R4
  BHS     EndWh1        @   {
  LDR     R6, [R9]      @       elemB = word[adrTmp];

If:                     @       if (elmA == elemB)
  CMP     R5, R6        @       {
  BNE     Else         
  STR     R5, [R0]      @           word[adrC] == elemA;
  ADD     R0, R0, #4    @           adrC == adrC + 4;
                        @       }
Else:                   
  ADD     R9, R9, #4    @       adrTmp = adrTmp + 4;
  ADD     R8, R8, #4    @       iB = iB + 1;
  B       While1        @   }

EndWh1:
  ADD     R1, R1, #4    @   adrA = adrA +4;  
  ADD     R7, R7, #1    @   iA = iA + 1;
  B       While         @ }  

EndWh:  
  
  
  @ End of program ... check your result

End_Main:
  BX    lr

