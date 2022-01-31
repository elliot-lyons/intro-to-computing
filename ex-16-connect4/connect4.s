  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb
  .global  isWinning


@ isWinning subroutine
@ Determines whether a given slot in a connect 4 board contains a disc
@   that is part of a winning run of 4 discs of the same colour.
@ Parameters:
@   R0: address of connect 4 board
@   R1: row number
@   R2: column number
@ Return:
@   R0: 1 if yellow wins, 2 if red wins, -1 if the slot is empty, 0 otherwise

isWinning:

  PUSH (R4-R12, LR)

  MOV   R4, R0            @ localAddress = address;
  MOV   R5, R1            @ localRow = rowNumber;
  MOV   R6, R2            @ localCol = colNumber;
  MOV   R7, #0            @ count = 0;

  MOV   R8, #6            @ index = 6;
  MUL   R8, R5, R8        @ index = localRow * 6;
  ADD   R8, R8, R6        @ index = index + localCol;
  
  LDRB  R9, [R4, R8]      @ colour = localAddress[localRow][localCol]
  LDR   R8, = colour
  STR   R9, [R8]          @ storing colour in memory

  CMP   R9, #1            @ if (colour != 1 && colour != 2)
  BEQ   .LNotEmpty        @ {
  CMP   R9, #2            
  BEQ   .LNotEmpty
  MOV   R0, #-1           @   return -1;
  B     .LEndWinning
                          @ }
.LNotEmpty:
  // checking for connect four in horizontal direction
  
  SUB   R10, R6, #3
  ADD   R11, R6, #3

.LWinningFor1:  
  CMP   R10, R11          @ for (int i = localCol - 3; i <= localCol + 3; i++)
  BHI   .LWinningFor1End  @ {
  CMP   R10, #0           @   if (i >= 0 && i <= 6)
  BLO   .LWinningEndIf1   @   {   
  CMP   R10, #6           
  BHI   .LWinningEndIf1
  
  MOV   R8, #6
  MUL   R8, R5, R8
  ADD   R8, R8, R10
  LDRB  R12, [R4, R8]
   
  CMP   R12, R9           @     if (localAddress[localRow][i] == colour)
  BNE   .LElseWinning1    @     {
  ADD   R7, R7, #1        @       count++;
  
  CMP   R7, #4
  BNE   .LNotCount1       @       if (count == 4)
  MOV   R0, R9            @       {
  B     .LEndWinning      @         return colour;
                          @       }
                          @     } 
.LElseWinning1:           @     else
                          @     {
  MOV   R7, #0            @       count = 0;
                          @     }
.LWinningEndIf1:          @   }
  ADD   R10, R10, #1      
  B     .LWinningFor1     @ }

.LWinningFor1End:
  MOV   R7, #0            @ count = 0;

  // checking for connect four in vertical direction
  
  SUB   R10, R5, #3
  ADD   R11, R5, #3

.LWinningFor2             @ for (int i = localRow - 3; i <= localRow + 3; i++)
  CMP   R10, R11
  BHI   .LWinningFor2End
                          @ {
  CMP   R10, #0           @   if (i >= 0 && i <= 5)
  BLO   .LWinningEndIf2
  CMP   R10, #5
  BHI   .LWinningEndIf2
  
  MOV   R8, #6
  MUL   R8, R10, R8
  ADD   R8, R8, R6
  LDRB  R12, [R4, R8]     @   {

  CMP   R12, R9           @     if (localAddress[i][localCol] == colour)
  BNE   .LElseWinning2    @     {
  ADD   R7, R7, #1        @       count++;
 
  CMP   R7, #4            @       if (count == 4)
  BNE   .LNotCount2       @       {
  MOV   R0, R9            @         return colour;
  B     .LEndWinning      @       }
                          @     }
  
.LElseWinning2:           @     else
                          @     {
  MOV   R7, #0            @       count = 0;
                          @     }
.LWinningEndIf2:          @   }
  ADD   R10, R10, #1
  B     .LWinningFor2     @ }

  MOV   R7, #0            @ count = 0;

  // checking for connect four in diagonal direction (left to right and down to up)
  
  SUB   R10, R6, #3        @ int j = localCol - 3;
  SUB   R11, R5, #3        @ int i = localRow - 3;

  ADD   R12, R6, #3        @ limitOne = localCol + 3; 
  LDR   R8, [limitOne]
  STRB  R12, [R8]
  ADD   R12, R5, #3        @ limitTwo = localRow + 3; 
  LDR   R8, [limitTwo]
  STRB  R12, [R8]

.LWinningFor3               @ for (int i = localRow - 3; i <= localRow + 3 && j <= localCol + 3; i++)
  LDR   R8, [limitOne]      @ {
  LDRB  R12, [R8]
  CMP   R10, R12
  BHI   .LWinningFor3End
  LDR   R8, [limitTwo]
  LDRB  R12, [R8]
  CMP   R11, R12
  BHI   .LWinningFor3End  
  
  CMP   R11, #0             @   if (i >= 0 && i <= 5 && j >= 0 && j <= 6)
  BLO   .LWinningEndIf3
  CMP   R11, #5
  BHI   .LWinningEndIf3
  CMP   R10, #0
  BLO   .LWinningEndIf3
  CMP   R10, #6
  BHI   .LWinningEndIf3
  
  MOV   R8, #6
  MUL   R8, R10, R8
  ADD   R8, R8, R11
  @   {  
  @     if (localAddress[i][j] == colour)
  @     {
  @       count++;
  
  @       if (count == 4)
  @       {
  @         return colour;
  @       }
  @     }
  
  @     else
  @     {
  @       count = 0;
  @     }
  @   }

.LWinningEndIf3:  

  @   j++;
  @ }
.LWinningFor3End:

  @ count = 0;

  // checking for connect four in other diagonal direction (left to right and up to down)
  @ j = localCol - 3;

  @ for (int i = localRow + 3; i >= localRow - 3 && j <= localCol + 3; i--)
  @ {
  @   if (i >= 0 && i <= 5 && j >= 0 && j <= 6)
  @   {  
  @     if (localAddress[i][j] == colour)
  @     {
  @       count++;
  
  @       if (count == 4)
  @       {
  @         return colour;
  @       }
  @     }
  
  @     else
  @     {
  @       count = 0;
  @     }
  @   }

  @   j++;
  @ }

  @ return 0;

.LEndWinning:

  POP   (R4-R12, PC)

  BX    lr

  limitOne:
    .space 4

  limitTwo:
    .space 4
