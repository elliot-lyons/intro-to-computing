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
  @ You can use either
  @
  @   The System stack (R13/SP) with PUSH and POP operations
  @
  @   or
  @
  @   A user stack (R12 has been initialised for this purpose)
  @


  LDR   R10, = 10                 @ 10 = 10;

  LDR   R4, = 0
For:                              @ for (offset = 0; char != null; offset++)
                                  @ {
  LDRB  R5, [R1, R4]              @   char = String[address + offset];
  CMP   R5, #0x0
  BEQ   EndFor  
  CMP   R5, #'0'                  @   if (char >= '0' && char <= '9')
  BLO   Else                      @   {
  CMP   R5, #'9'                  
  BHI   Else                      
  
  SUB   R5, R5, #0x30             @     char = char - 0x30; (this turns a number 
                                  @     character into a value)
  ADD   R4, R4, #1                @     offset++;  
While:                            @     while (nextChar >= '0' && nextChar <= '9')
                                  @     {
  LDRB   R6, [R1, R4]             @       nextChar = String[address + offset];            
  CMP   R6, #'0'                      
  BLO   EndWh                     @       this while loop checks to see whether the value in the
  CMP   R6, #'9'                  @       String is multiple digits. Once it has converted the
  BHI   EndWh                     @       characters into one value, it pops it onto the stack     

  SUB   R6, R6, #0x30             @       nextChar = nextChar - 0x30; (this turns a number 
                                  @       character into a value)
  MUL   R5, R5, R10               @       char = char * 10;
  ADD   R5, R5, R6                @       char = char + nextChar;
  ADD   R4, R4, #1                @       offset++;                     
  B     While                     @     } 
  
EndWh:  
  STR   R5, [SP, #-4]!            @     push char;     
  B     For                       @     jump back to top of for loop. Offset++ (the continuation
                                  @     condition of the original for loop) is already done in 
                                  @     the while loop, so no need to do it here.                       
                                  @   }

Else:                             @   else if (offset >= 1)
  CMP   R4, #1
  BLO   EndElse                   @   {
  
  CMP   R5, #'+'                  @     if (char == '+')
  BNE   Else1                     @     {      
  LDR   R7, [SP], #4              @       pop x off the system stack;
  LDR   R8, [SP], #4              @       pop y off the system stack;
  ADD   R7, R8, R7                @       x = y + x;   
  STR   R7, [SP, #-4]!            @       push x onto system stack;
                                  @     }
Else1:  
  CMP   R5, #'-'                  @     if (char == '-')
  BNE   Else2                     @     {
  LDR   R7, [SP], #4              @       pop x off the system stack;
  LDR   R8, [SP], #4              @       pop y off the system stack;
  SUB   R7, R8, R7                @       x = y - x;
  STR   R7, [SP, #-4]!            @       push x onto system stack;
                                  @     }
Else2:
  CMP   R5, #'*'                  @     if (char == '*')
  BNE   EndElse                   @     {
  LDR   R7, [SP], #4              @       pop x off the system stack;
  LDR   R8, [SP], #4              @       pop y off the system stack;
  MUL   R7, R8, R7                @       x = y * x;
  STR   R7, [SP, #-4]!            @       push x onto system stack;
                                  @     }
EndElse:                          @   }
  ADD   R4, R4, #1                @ }
  B     For

EndFor:
  LDR   R0, [SP], #4              @ result = number on top of stack;     



  @ End of program ... check your result

End_Main:
  BX    lr

