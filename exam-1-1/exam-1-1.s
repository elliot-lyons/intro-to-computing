  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb
  .global  Main

Main:
  

  @
  @ Write your program here
  @

  @
  @ REMEMBER: Sets are stored in memory in the format ...
  @
  @   size, element1, element2, element3, etc.
  @
  @ where size is the number of elements in the set, element1 is
  @   the first element, element2 is the second element, etc.
  @ 


  @
  @ Debugging tips:
  @
  @ If using the View Memory window
  @   - view set A using address "&setA" and size 64
  @   - view set B using address "&setB" and size 64
  @   - view set C using address "&setC" and size 64
  @
  @ If using a Watch Expression
  @   view set A using expression "(int[16])setA"
  @   view set B using expression "(int[16])setB"
  @   view set C using expression "(int[16])setC"
  @
  @ BUT REMEMBER, the first value you see should be the size, 
  @  the second value will be the first element, etc. (see above!)

  @ End of program ... check your result


  LDR   R4, [R1]                    @ countA = int[addressA];
  LDR   R5, [R2]                    @ countB = int[addressB];
  LDR   R11, = 0x20010000           @ union = [addressUnion];
  ADD   R9, R4, R5                  @ countUnion = countA + countB;
  LDR   R7, = 0                     @ currentCountA = 0;
  LDR   R8, = 0                     @ currentCountB = 0;
  
  CMP   R4, #0                      @ if ( countA == 0 && countB ==0 )       
  BNE   Else                        @ {
  CMP   R5, #0                      @   setC = empty;
  BEQ   EndEmptySet                 @ }

EmptySetA:                          @ if ( countA == 0 && countB != 0 )
  CMP   R8, R5                      @ { 
  BHI   EndEmptySet                 
  LDR   R3, [R2]
  STR   R3, [R0]
  ADD   R2, R2, #4                  @   setC = setB;
  ADD   R8, R8, #1
  ADD   R0, R0, #4
  B     EmptySetA                   @ }

Else:
  CMP   R5, #0      
  BNE   EndElse

EmptySetB:                          @ if ( countA != 0 && countB == 0 )
  CMP   R7, R4                      @ {
  BHI   EndEmptySet
  LDR   R3, [R1]
  STR   R3, [R0]
  ADD   R1, R1, #4                  @     setC = setA;  
  ADD   R7, R7, #1
  ADD   R0, R0, #4
  B     EmptySetB                   @ }
  
EndElse:  
  ADD   R0, R0, #4                  @ addressC = addressC + 4;
  LDR   R6, = 1                     @ countC = 1;

While:
  CMP   R7, R4                      @ while ( currentCountA < countA )
  BHS   While1                      @ {
  ADD   R1, R1, #4                  @     addressA = addressA + 4;
  LDR   R3, [R1]                    @     charA = char[addressA];
  STR   R3, [R11]                   @     store charA in [addressUnion]
  ADD   R11, R11, #4                @     addressUnion = addressUnion + 4;
  ADD   R7, R7, #1                  @     currentCountA = currentCountA + 1;
  B     While                       @ }  

While1:
  CMP   R8, R5                      @ while ( currentCountB < countB )
  BHS   EndWhile1                   @ {
  ADD   R2, R2, #4                  @     addressB = addressB + 4;
  LDR   R3, [R2]                    @     charB = char[addressB];
  STR   R3, [R11]                   @     store charB in [addressUnion]
  ADD   R11, R11, #4                @     addressUnion = addressUnion + 4;
  ADD   R8, R8, #1                  @     currentCountB = currentCountB + 1;
  B     While1                      @ }  

EndWhile1:
  LDR   R3, = 4                     @ reset = 4;
  SUB   R7, R7, #1                  @ currentCountA = currentCountA - 1;
  SUB   R8, R8, #1                  @ currentCountB = currentCountB - 1;
  MUL   R7, R7, R3                  @ currentCountA = currentCountA * reset;
  SUB   R1, R1, R7                  @ addressA = addressA - currentCountA;
  MUL   R8, R8, R3                  @ currentCountB = currentCountB * reset;
  SUB   R2, R2, R8                  @ addressB = addressB - currentCountB;

  LDR   R7, = 1                     @ currentCountA = 1;

While2:  
  CMP   R7, R4                      @ while ( currentCountA <= countA )
  BHI   EndWhile2                   @ {
  LDR   R3, [R1]                    @   charA = char[addressA]
  ADD   R10, R4, #1                 @   currentCountUnion = countA + 1;
  LDR   R8, = 4                     @   temp = 4;
  LDR   R11, = 0x20010000           @   union = [addressUnion]
  MUL   R8, R8, R4                  @   temp = temp * countA;
  ADD   R11, R11, R8                @   addressUnion = addressUnion * temp ( addressUnion * 4 countA )

While3:
  CMP   R10, R9                     @   while ( currentCountUnion <= countUnion )
  BHI   EndWhile3                   @   {  
  LDR   R12, [R11]                  @     charU = char[addressUnion]
  CMP   R3, R12                     @     if ( char A != charU )
  BEQ   EndWhile3                   @     {
  ADD   R11, R11, #4                @         addressUnion = addressUnion + 4;    
  ADD   R10, R10, #1                @         currentCountUnion = currentCountUnion + 1;
  CMP   R10, R9                     @         if ( currentCountUnion > countUnion )
  BLS   While3                      @         {
  STR   R3, [R0]                    @             store charA in [addressC];
  ADD   R0, R0, #4                  @             addressC = addressC + 4;
  ADD   R6, R6, #1                  @             countC = countC + 1;                    
                                    @         }
                                    @      }
                                    @      else
                                    @      {
                                    @          break;
                                    @      }
EndWhile3:                          @    }
  ADD   R7, R7, #1                  @   currentCountA = currentCountA + 1;
  ADD   R1, R1, #4                  @   addressA = addressA + 4;
  B     While2                      @  }

EndWhile2:
  LDR   R8, =1                      @ currentCountB = 1;

While4:
  CMP   R8, R5                      @ while ( currentCountB <= countB )
  BHI   EndWhile4                   @ {
  LDR   R3, [R2]                    @   charB = char[addressB]
  LDR   R10, = 1                    @   currentCountUnion = 1;
  LDR   R11, = 0x20010000           @   addressUnion = original [addressUnion];
  
While5:
  CMP   R10, R4                     @   while ( currentCountUnion <= countA )
  BHI   EndWhile5                   @   {  
  LDR   R12, [R11]                  @     charU = char[addressUnion]
  CMP   R3, R12                     @     if ( char B != charU )
  BEQ   EndWhile5                   @     {
  ADD   R11, R11, #4                @         addressUnion = addressUnion + 4;    
  ADD   R10, R10, #1                @         currentCountUnion = currentCountUnion + 1;
  CMP   R10, R4                     @         if ( currentCountUnion > countA )
  BLS   While5                      @         {
  STR   R3, [R0]                    @             store charB in [addressC];
  ADD   R0, R0, #4                  @             addressC = addressC + 4;
  ADD   R6, R6, #1                  @             countC = countC + 1;
                                    @         }
                                    @      }
                                    @      else
                                    @      {
                                    @          break;
                                    @      }
EndWhile5:                          @    }
  ADD   R8, R8, #1                  @   currentCountB = currentCountB + 1;
  ADD   R2, R2, #4                  @   addressB = addressB + 4;
  B   While4                        @  }

EndWhile4:
  LDR     R3, = 4                   @ reset = 4;
  MUL     R3, R3, R6                @ reset = reset * countC;
  SUB     R0, R0, R3                @ addressC = addressC - reset;
  SUB     R6, R6, #1                @ countC = countC - 1;
  STR     R6, [R0]                  @ store countC in [addressC];  

EndEmptySet:

End_Main:
  BX    lr

