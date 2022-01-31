  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb
  
  .global   searchTB
  .global   searchTLBR


@ searchTB subroutine
@
@ Parameters:
@   R0: start address of 2D array
@   R1: start address of string
@ Return:
@   R0: 0 if the string was not found, 1 if it was found

searchTB:

  PUSH    {R4 - R12, LR}

  MOV   R4, R0                 @ localArray = arrayAddress;
  MOV   R5, R1                 @ localString = stringAddress;
  MOV   R12, #12               @ length = 12;    (both column and row lengths)
  
  MOV   R7, #0   
.LSearchTBFor1:        
  CMP   R7, R12                @ for (int col = 0; col < length; col++)
  BHS   .LSearchTBFor1End      @ {
  MOV   R8, #0                 @   count = 0;
  
  MOV   R6, #0   
.LSearchTBFor2:                @   for (int row = 0; row < length; row++) 
  CMP   R6, R12                @   {
  BHS   .LSearchTBFor2End  
  
  MUL   R9, R6, R12            @     index = row * length;
  ADD   R9, R9, R7             @     index = index + col;
  
  LDRB  R10, [R4, R9]          @     arrayChar = array[localArray + row][localArray + col] 
  LDRB  R11, [R5, R8]          @     stringChar = array[localString + count];
  
  CMP   R11, #0x0              @     if (stringChar == null)
  BNE   .LSearchTBElse1        @     {
  MOV   R0, #1                 @       return 1;
  B     .LSearchTBEnd          @     }  
  
.LSearchTBElse1:   
  CMP   R10, R11               @     else if (arrayChar == stringChar)
  BNE   .LSearchTBElse2        @     {
  ADD   R8, R8, #1             @       count++;
  B     .LSearchTBEndElse1     @     }
  
.LSearchTBElse2:               @     else
                               @     {
  MOV   R8, #0                 @       count = 0;
                               @     }
.LSearchTBEndElse1:    
  ADD   R6, R6, #1   
  B     .LSearchTBFor2         @   }  
  
.LSearchTBFor2End:     
    
  LDRB  R11, [R5, R8]          @     stringChar = array[localString + count];
    
  CMP   R11, #0x0              @     if (stringChar == null)       // this is for exceptional cases, where 
  BNE   .LSearchTBIfEnd1       @     {                             // the string is at the very end of the column
  MOV   R0, #1                 @       return 1;                   // this makes sure the program recognises that 
  B     .LSearchTBEnd          @     }                             // the string does exist in the array
    
.LSearchTBIfEnd1:  
  ADD   R7, R7, #1     
  B     .LSearchTBFor1         @ }
    
.LSearchTBFor1End:     
  MOV   R0, #0                 @ return 0;

.LSearchTBEnd:  


  POP   {R4 - R12, PC} 



@ searchTLBR subroutine
@
@ Parameters:
@   R0: start address of 2D array
@   R1: start address of string
@ Return:
@   R0: 0 if the string was not found, 1 if it was found
searchTLBR:

  PUSH    {R4 - R12, LR}

  MOV   R4, R0                    @ localArray = arrayAddress;
  MOV   R5, R1                    @ localString = stringAddress;
  MOV   R12, #12                  @ length = 12;    (both column and row lengths)

  MOV   R7, #0    
.LSearchTLBRFor1:                 @ for (int row = 0; row < length; row++)
  CMP   R7, R12                   @ {
  BHS   .LSearchTLBRFor1End   

  MOV   R8, #0    
.LSearchTLBRFor2:                 @   for (int col = 0; col < length; col++)
  CMP   R8, R12                   @   {
  BHS   .LSearchTLBRFor2End     

  MUL   R9, R7, R12               @     index = row * length;
  ADD   R9, R9, R8                @     index = index + col;

  LDRB  R10, [R4, R9]             @     arrayChar = array[localArray + row][localArray + col] (or = array[index]);
  LDRB  R11, [R5]                 @     stringChar = array[localString];

  CMP   R10, R11                  @     if (arrayChar == stringChar)
  BNE   .LSearchTLBRWhile1EndOut  @     {
  MOV   R6, #0                    @       count = 0;  

.LSearchTLBRWhile1:   
  CMP   R10, R11                  @       while (arrayChar == stringChar && (row + count < length) && (col + count < length))
  BNE   .LSearchTLBRWhile1End
  ADD   R9, R7, R6
  CMP   R9, R12
  BHS   .LSearchTLBRWhile1EndOut
  ADD   R9, R8, R6
  CMP   R9, R12
  BHS   .LSearchTLBRWhile1EndOut
                                  @       {
  ADD   R6, R6, #1                @         count++; 
  ADD   R9, R7, R6                @         index = row + count;
  MUL   R9, R9, R12               @         index = index * length;
  ADD   R9, R9, R8                @         index = index + col;
  ADD   R9, R9, R6                @         index = index + count;

  LDRB  R10, [R4, R9]             @         arrayChar = array[localArray + row + count][localArray + col + count] (or = array[index]);
  LDRB  R11, [R5, R6]             @         stringChar = array[localString + count];   
  B     .LSearchTLBRWhile1        @       }

.LSearchTLBRWhile1End:  
  CMP   R11, #0x0                 @       if (stringChar == null)
  BNE   .LSearchTLBRWhile1EndOut  @       {
  MOV   R0, #1                    @         return 1;
  B     .LSearchTLBREnd           @       }
                                  @     }

.LSearchTLBRWhile1EndOut:
  ADD   R8, R8, #1  
  B     .LSearchTLBRFor2          @   }

.LSearchTLBRFor2End:
  ADD   R7, R7, #1  
  B     .LSearchTLBRFor1          @ }

.LSearchTLBRFor1End:  
  MOV   R0, #0                @ return 0;

.LSearchTLBREnd:

  POP   {R4 - R12, PC}

.end