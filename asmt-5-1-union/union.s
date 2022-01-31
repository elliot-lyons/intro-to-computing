  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb
  .global  Main

Main:
  
  @
  @ write your program here
  @


  LDR   R3, [R1]         @ countA = word[addressA]
  LDR   R4, [R2]         @ countB = word[addressB]
  ADD   R1, R1, #4       @ addressA = addressA + 4;
  ADD   R2, R2, #4       @ addressB = addressB + 4;
  ADD   R0, R0, #4       @ addressC = addressC + 4;
  LDR   R5, =0           @ countC = 0;
  LDR   R9, =4           @ four = 4;

While:                   @ while ( countC < countA )  
  CMP   R5, R3           @ { 
  BHS   EndWhile    
  LDR   R6, [R1]         @    wordA = word[addressA]
  STR   R6, [R0]         @    store wordA [addressC] 
  ADD   R1, R1, #4       @    addressA = addressA + 4;
  ADD   R0, R0, #4       @    addressC = addressC + 4;
  ADD   R5, R5, #1       @    countC = countC + 1;
  B     While            @ }

EndWhile:
  MUL   R10, R3, R9      @ wordCountA = countA * 4;

While1:                  @ while ( countB != 0 )
  CMP   R4, #0           @ {
  BEQ   EndWhile1
  MOV   R8, #0           @   newCount = 0;
  SUB   R1, R1, R10      @   this resets address1 so that it is at the first value in address1
  LDR   R7, [R2]         @   wordB = word[addressB]

While2:                  @   while ( newCount < countA )
  CMP   R8, R3           @   {
  BHS   EndWhile2
  LDR   R6, [R1]         @      load wordA[addressA]   
  CMP   R6, R7           @      if ( wordB == wordA )
  BEQ   Duplicates       @      {   disregard   }
  ADD   R1, R1, #4       @      else 
  ADD   R8, R8, #1       @      {   address1 = address1 + 4;
  B   While2             @          newCount = newCount + 1;    }
                         @   }    
EndWhile2:
  STR   R7, [R0]         @   a value from B will only get here if it's not shared with A
  ADD   R0, R0, #4       @   we can then store the value in Union (address[C]) and add 4 to addressC
  ADD   R5, R5, #1       @   countC = countC +1; 

Duplicates:
  SUB   R4, R4, #1       @   countB = countB - 1;
  MUL   R10, R8, R9      @   wordCountA = newCount * 4;
  ADD   R2, R2, #4       @   addressB = addressB + 4;
  B     While1           @ }

EndWhile1:  
  MUL   R9, R5, R9       @ wordsInaddressC = countC * 4;
  ADD   R9, R9, #4       @ this is adding the extra word that is occupied by the no. of values in addressC
  SUB   R0, R0, R9       @ this brings us back to the first word in addressC (the no. of values in addressC)     
  STR   R5, [R0]         @ this then stores the amount of values in C at the start of addressC



  @ End of program ... check your result

End_Main:
  BX    lr

