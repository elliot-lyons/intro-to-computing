  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb
  
  .global   quicksort
  .global   partition
  .global   swap

@ quicksort subroutine
@ Sort an array of words using Hoare's quicksort algorithm
@ https://en.wikipedia.org/wiki/Quicksort 
@
@ Parameters:
@   R0: Array start address
@   R1: lo index of portion of array to sort
@   R2: hi index of portion of array to sort
@
@ Return:
@   none

quicksort:
  PUSH    {R4-R7, LR}             @ add any registers R4...R12 that you use

  MOV   R4, R0                    @ localAddress = address;
  MOV   R5, R1                    @ localLo = lo;
  MOV   R6, R2                    @ localHi = hi;
  LDR   R7, = 0                   @ int p = 0;

  CMP   R5, R6
  BGE   EndIfQuick                @ if (lo < hi) 
                                  @ {
  MOV   R0, R4
  MOV   R1, R5                    @   moving the required variables into the correct parameters
  MOV   R2, R6
  BL    partition   
  MOV   R7, R0                    @   p = partition(array, lo, hi);

  MOV   R0, R4
  MOV   R1, R5                    @   moving the required variables into the correct parameters
  SUB   R2, R7, #1
  BL    quicksort                 @   quicksort(array, lo, p - 1);

  MOV   R0, R4
  ADD   R1, R7, #1                @   moving the required variables into the correct parameters
  MOV   R2, R6
  BL    quicksort                 @   quicksort(array, p + 1, hi);
  
  EndIfQuick:                     @ }

  POP     {R4-R7, PC}             @ add any registers R4...R12 that you use


@ partition subroutine
@ Partition an array of words into two parts such that all elements before some
@   element in the array that is chosen as a 'pivot' are less than the pivot
@   and all elements after the pivot are greater than the pivot.
@
@ Based on Lomuto's partition scheme (https://en.wikipedia.org/wiki/Quicksort)
@
@ Parameters:
@   R0: array start address
@   R1: lo index of partition to sort
@   R2: hi index of partition to sort
@
@ Return:
@   R0: pivot - the index of the chosen pivot value

partition:
  PUSH    {R4-R10, LR}            @ add any registers R4...R12 that you use

  MOV   R4, R0                    @ localAddress = address;
  MOV   R5, R1                    @ localLo = lo
  MOV   R6, R2                    @ localHi = hi;

  LDR   R7, [R4, R6, LSL #2]      @ pivot = array[hi];
  MOV   R8, R5                    @ i = lo;

  MOV   R9, R5
ForPart:                          @ for (j = lo; j <= hi; j++) {
  CMP   R9, R6
  BGT   EndForPart

  LDR   R10, [R0, R9, LSL #2]
  CMP   R10, R7                   @   if (array[j] < pivot) {
  BHS   EndIfPart
  
  MOV   R0, R4
  MOV   R1, R8                    @     moving the required variables into the correct parameters   
  MOV   R2, R9
  BL    swap                      @     swap (array, i, j);
  ADD   R8, R8, #1                @     i = i + 1;

EndIfPart:                        @   }          
  ADD   R9, R9, #1                
  B     ForPart

EndForPart:                       @ }
  MOV   R0, R4
  MOV   R1, R8                    @ moving the required variables into the correct parameters
  MOV   R2, R6
  BL    swap                      @ swap(array, i, hi);
  
  MOV   R0, R8                    @ return i;

  POP     {R4-R10, PC}            @ add any registers R4...R12 that you use


@ swap subroutine
@ Swap the elements at two specified indices in an array of words.
@
@ Parameters:
@   R0: array - start address of an array of words
@   R1: a - index of first element to be swapped
@   R2: b - index of second element to be swapped
@
@ Return:
@   none

swap:
  PUSH    {R4, R5, LR}

  LDR   R4, [R0, R1, LSL #2]      @ x = array[originalAddress + index1];
  LDR   R5, [R0, R2, LSL #2]      @ y = array[originalAddress + index2];
  STR   R4, [R0, R2, LSL #2]      @ store x at index2;
  STR   R5, [R0, R1, LSL #2]      @ store y at index1;

  POP     {R4, R5, PC}


.end