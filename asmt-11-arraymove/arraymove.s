  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb
  .global  Main

Main:

  @
  @ write your program here
  @

  SUB   R3, R1, R2      @ int sum = oldIndex - newIndex;
  LDR   R4, = 4         @ int four = 4;
  MUL   R4, R1, R4      @ oldAddress = 4 * oldIndex;
  ADD   R4, R0, R4      @ oldAddress = baseAddress + oldAddress;
  LDR   R6, [R4]        @ int numberChange = array[oldAddress];

  CMP   R3, #0          @ if (sum == 0)   (i.e. the new index == the old index, hence no movement of numbers)
  BEQ   EndElse         @ { terminate; }
  LDR   R7, = 4         @   (initialising count = 4 here for the two for loops below)
  CMP   R3, #0          
  BLT   For1            
                        @ else
For:                    @ {
  CMP   R3, #0          @   for (count = 4; sum > 0; sum--) 
  BLS   EndFor          @   {
  SUB   R8, R4, R7      @     int x = oldAddress - count;             
  LDR   R9, [R8]        @     int currentNumber = array[x];
  ADD   R8, R8, #4      @     x = x + 4;
  STR   R9, [R8]        @     array[x] = currentNumber;     
  ADD   R7, R7, #4      @     count = count + 4;
  SUB   R3, R3, #1      @   }
  B     For             @       the above for loop is for handling cases where the index of the number being moved
                        @       is greater than the index of where the number is being moved to
For1:                   
  CMP   R3, #0          @   for (count = 4; sum < 0; sum++)  
  BGE   EndFor          @   {
  LDR   R9, [R4, R7]    @     int currentNumber = array[oldAddress + count];
  SUB   R7, R7, #4      @     count = count - 4;
  STR   R9, [R4, R7]    @     array[oldAddress + count] = currentNumber;
  ADD   R7, R7, #8      @     count = count + 8;
  ADD   R3, R3, #1      @     sum = sum + 1;
  B     For1            @   }
                        @       the above for loop is for the opposite cases; where the original index of the number being 
                        @       moved is less than the index of where the number is being moved to
EndFor:                 
  STR   R6, [R0, R2, LSL #2]        @   array[baseAddress + (newIndex * 4)] = numberChange;
                        @ }
EndElse:

  @ End of program ... check your result

End_Main:
  BX    lr

