  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb
  
  .global   searchLR

@ searchLR subroutine
@
@ Parameters:
@   R0: start address of 2D array
@   R1: start address of string
@ Return:
@   R0: 0 if the string was not found, 1 if it was found

searchLR:

  PUSH    {R4 - R12, LR}

  MOV   R4, R0                @ localArray = arrayAddress;
  MOV   R5, R1                @ localString = stringAddress;
  MOV   R12, #12              @ length = 12;    (both column and row lengths)

  MOV   R6, #0    
.LSearchLRFor1:     
  CMP   R6, R12               @ for (int row = 0; row < length; row++)
  BHS   .LSearchLRFor1End     @ {
  MOV   R8, #0                @   count = 0;

  MOV   R7, #0    
.LSearchLRFor2:      
  CMP   R7, R12               @   for (int col = 0; col < length; col++)
  BHS   .LSearchLRFor2End     @   {

  MUL   R9, R6, R12           @     index = row * length;
  ADD   R9, R9, R7            @     index = index + col;

  LDRB  R10, [R4, R9]         @     arrayChar = array[localArray + row][localArray + col] (or = array[index]);
  LDRB  R11, [R5, R8]         @     stringChar = array[localString + count];

  CMP   R11, #0x0             @     if (stringChar == null)
  BNE   .LSearchLRElse1       @     {
  MOV   R0, #1                @       return 1;
  B     .LSearchLREnd         @     }  

.LSearchLRElse1:    
  CMP   R10, R11              @     else if (arrayChar == stringChar)
  BNE   .LSearchLRElse2       @     {
  ADD   R8, R8, #1            @       count++;
  B     .LSearchLREndElse1    @     }

.LSearchLRElse2:              @     else
                              @     {
  MOV   R8, #0                @       count = 0;
                              @     }
.LSearchLREndElse1:
  ADD   R7, R7, #1
  B     .LSearchLRFor2        @   }

.LSearchLRFor2End:

  LDRB  R11, [R5, R8]         @     stringChar = array[localString + count];

  CMP   R11, #0x0             @     if (stringChar == null)       // this is for exceptional cases, where 
  BNE   .LSearchLRIfEnd1      @     {                             // the string is at the very end of the row
  MOV   R0, #1                @       return 1;                   // this makes sure the program recognises that 
  B     .LSearchLREnd         @     }                             // the string does exist in the array

.LSearchLRIfEnd1:
  ADD   R6, R6, #1
  B     .LSearchLRFor1        @ }

.LSearchLRFor1End:
  MOV   R0, #0                @ return 0;

.LSearchLREnd:  


  POP   {R4 - R12, PC}

.end