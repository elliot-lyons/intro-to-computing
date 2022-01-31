  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb
  
  .global  get9x9
  .global  set9x9
  .global  average9x9
  .global  blur9x9


@ get9x9 subroutine
@ Retrieve the element at row r, column c of a 9x9 2D array
@   of word-size values stored using row-major ordering.
@
@ Parameters:
@   R0: address - array start address
@   R1: r - row number
@   R2: c - column number
@
@ Return:
@   R0: element at row r, column c

get9x9:
  PUSH    {R4-R6, LR}                       @ add any registers R4...R12 that you use

  LDR   R4, = 9                             @ rowAndColSize = 9;
  MUL   R5, R1, R4                          @ index = r * rowAndColSize;
  ADD   R5, R5, R2	                        @ index = index + c;
  LDR   R6, [R0, R5, LSL #2]                @ elem = array[index]; 
  MOV   R0, R6                              @ return elem;

  POP     {R4-R6, PC}                       @ add any registers R4...R12 that you use



@ set9x9 subroutine
@ Set the value of the element at row r, column c of a 9x9
@   2D array of word-size values stored using row-major
@   ordering.
@
@ Parameters:
@   R0: address - array start address
@   R1: r - row number
@   R2: c - column number
@   R3: value - new word-size value for array[r][c]
@
@ Return:
@   none

set9x9:
  PUSH    {R4-R5, LR}                       @ add any registers R4...R12 that you use

  LDR   R4, = 9                             @ rowAndColSize = 9;
  MUL   R5, R1, R4                          @ index = r * rowAndColSize;
  ADD   R5, R5, R2	                        @ index = index + c;
  STR   R3, [R0, R5, LSL #2]                @ array[index] = value; 

  POP     {R4-R5, PC}                       @ add any registers R4...R12 that you use



@ average9x9 subroutine
@ Calculate the average value of the elements up to a distance of
@   n rows and n columns from the element at row r, column c in
@   a 9x9 2D array of word-size values. The average should include
@   the element at row r, column c.
@
@ Parameters:
@   R0: address - array start address
@   R1: r - row number
@   R2: c - column number
@   R3: n - element radius
@
@ Return:
@   R0: average value of elements

average9x9:
  PUSH    {R4-R11, LR}              @ add any registers R4...R12 that you use

  MOV   R11, R0                     @ localAddress = address;
  MOV   R9, R2                      @ localC = c;
  MOV   R10, R3                     @ localRadius = radius;

  LDR   R4, = 0                     @ sum = 0;
  LDR   R5, = 0                     @ count = 0;
  ADD   R6, R1, R10                 @ r + radius;
  ADD   R7, R9, R10                 @ c + radius;

  SUB   R8, R1, R10
ForAvg:                             @ for (row = r - radius; (row <= r + radius)
  CMP   R8, R6                      @           && (row < 9); row++)
  BGT   EndForAvg                   @ {
  CMP   R8, #9
  BGE   EndForAvg

  CMP   R8, #0                      @   if (row >= 0)
  BLT   EndFor1Avg                  @   {
  
  SUB   R12, R9, R10
For1Avg:                            @     for (col = c - radius; (col <= c + radius)
  CMP   R12, R7                     @                && (col < 9); col++)
  BGT   EndFor1Avg                  @     {
  CMP   R12, #9
  BGE   EndFor1Avg

  CMP   R12, #0                     @       if (col >= 0)
  BLT   EndIfAvg                    @       {
  MOV   R0, R11                     @         address = localAddress;
  MOV   R1, R8                      @         row = row;
  MOV   R2, R12                     @         col = col;
  BL    get9x9                      @         get = get9x9(address, row, col)
  ADD   R4, R4, R0                  @         sum = sum + get;                 
  ADD   R5, R5, #1                  @         count++;
                                    @       }
EndIfAvg:  
  ADD   R12, R12, #1                @     }
  B     For1Avg                     @   }

EndFor1Avg:  
  ADD   R8, R8, #1
  B     ForAvg                      @ }

EndForAvg:
  UDIV  R0, R4, R5                  @ return sum / count;

  POP     {R4-R11, PC}              @ add any registers R4...R12 that you use



@ blur9x9 subroutine
@ Create a new 9x9 2D array in memory where each element of the new
@ array is the average value the elements, up to a distance of n
@ rows and n columns, surrounding the corresponding element in an
@ original array, also stored in memory.
@
@ Parameters:
@   R0: addressA - start address of original array
@   R1: addressB - start address of new array
@   R2: n - radius
@
@ Return:
@   none

blur9x9:
  PUSH    {R4-R8, LR}       @ add any registers R4...R12 that you use

  MOV   R4, R0              @ localAddressA = addressA;
  MOV   R5, R1              @ localAddressB = addressB;
  MOV   R6, R2              @ localRadius = radius;

  LDR   R7, = 0
ForBlur:                    @ for (r = 0; r < 9; r++)
  CMP   R7, #9              @ {
  BHS   EndForBlur
  
  LDR   R8, = 0
ForBlur1:                   @   for (c = 0; c < 9; c++)
  CMP   R8, #9              @   {
  BHS   EndForBlur1   
  
  MOV   R0, R4
  MOV   R1, R7
  MOV   R2, R8
  MOV   R3, R6
  BL    average9x9          @     average = average9x9(address, r, c, radius);
  
  MOV   R3, R0
  MOV   R1, R7
  MOV   R2, R8
  MOV   R0, R5
  BL    set9x9              @     set9x9(newAddress, r, c, average);
  
  ADD   R8, R8, #1
  B     ForBlur1            @   }
  
EndForBlur1:
  ADD   R7, R7, #1  
  B     ForBlur             @ }

EndForBlur:        

  POP     {R4-R8, PC}       @ add any registers R4...R12 that you use

.end