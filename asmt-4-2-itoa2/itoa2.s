  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb
  .global  Main

Main:

  @
  @ write your program here
  @

  @
  @ TIP: To view memory when debugging your program you can ...
  @
  @   Add the following watch expression: (unsigned char [64]) strA
  @
  @   OR
  @
  @   Open a Memory View specifying the address 0x20000000 and length at least 11
  @   You can open a Memory View with ctrl-shift-p type view memory (cmd-shift-p on a Mac)
  @


  LDR     R11, =0x30         @ prefix = '0';
  LDR     R12, =0x00         @ null = null;
  STR     R11, [R0]          @ store prefix[address1]
  MOV     R2, R1             @ int number = numberGiven;
  LDR     R10, =10           @ int ten = 10;
  LDR     R4, =0             @ int nextSignificantDigit = 0
  LDR     R5, =0             @ int tenToThePowerOfCountTimesNextSignificantDigit = 0;
  LDR     R6, =-1            @ int minusOne = -1;
  LDR     R8, =1             @ int tenToThePowerOfCount = 1;
  LDR     R9, =0             @ int result = 0;

  CMP     R2, #0        
  BEQ     End           
  CMP     R2, #0             
  BGT     GreaterThan0       @ if (number < 0)
  LDR     R11, =0x2D         @ { prefix = '-'; 
  STR     R11, [R0]          @   store prefix [address1];
  MUL     R2, R2, R6         @   result = result * -1; }
  B       EndIf   

GreaterThan0:                @ if (number > 0)
  LDR     R11, =0x2B         @ { prefix = '+';
  STR     R11, [R0]          @   store prefix [address1]; }

EndIf:    
  ADD     R0, R0, #1         @ address1 = address1 + 4;
  MOV     R3, R2             @ int tenTest = number;
  LDR     R7, =0             @ count = 0;

While:
  CMP     R3, #10            @ while ( ; tenTest >= 10; count++ ) 
  BLT    EndWh                    
  UDIV    R3, R3, R10        @ { tenTest = tenTest / 10;        
  MUL     R8, R8, R10        @   tenToThePowerOfCount = tenToThePowerOfCount * 10; }
  ADD     R7, R7, #1                               
  B       While                         

EndWh:  
  CMP   R2, #10              @ if ( number < 10)  
  BGE   For
  ADD   R2, R2, 0x30         @   { number = number + 0x30; 
  STR   R2, [R0]             @   store number in address1
  ADD   R0, R0, #1           @   address1 = address1 + 1;   
  STR   R12, [R0]            @   store null in address1 }
  B     End                 

For:
  CMP   R8, #1               @ for ( ; tenToThePowerOfCount > 1; tenToThePowerOfCount = tenToThePowerOfCount / 10 )
  BLT   EndFor
  UDIV  R4, R2, R8           @ { nextSignificantDigit = number / tenToThePowerOfCount;
  ADD   R9, R4, #0x30        @   result = number + 0x30;
  STR   R9, [R0]             @   store result in address1;
  ADD   R0, R0, #1           @   address1 = address1 + address1;
  MUL   R5, R8, R4           @   tenToThePowerOfCountTimesNextSignificantDigit = tenToThePowerOfCount * nextSignificantDigit;
  SUB   R2, R2, R5           @   number = number - tenToThePowerOfCountTimesNextSignificantDigit; }
  UDIV  R8, R8, R10         
  B     For

EndFor:
  ADD   R0, R0, #1           @ address1 = address1 + 1;
  STR   R12, [R0]            @ store null in address1;
  B     End  
 
End:
  @ End of program ... check your result

End_Main:
  BX    lr

